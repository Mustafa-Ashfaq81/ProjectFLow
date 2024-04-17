// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/utils/inappmsgs_util.dart';

/*
This file contains the implementation of the gptapicall function. 
This function is used to call the OpenAI GPT-3 API to generate a 
list of subtasks from a given task heading and description.

*/



Future<List<Map<String,dynamic>>> gptapicall(String taskheading, String taskdesc) async
{

    const String apiKey = "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";    // GPT API Key
    const String deadline = "15th May 2024";    // Deadline
       // Prompt to be sent to the CHATGPT
    final String prompt = """   
        Think of yourself as a creative problem solver as well as an efficient project manager. 
        I will be sending you an idea which has an heading and a description and a deadline 
        (it will probably be a general overview of a project I want to do before some deadline), 
        what I want you to do is create a list of subtasks with headings and proper in-depth descriptions 
        (which will guide me how to break my idea into stepwise tasks, and pinpoint exactly what I need to do in the task 
        (dont make it brief, go in detail depending on the context), and assign deadlines to each subtask respectively 
        such that my idea is done in time) ... Now , I dont want them in text form, rather I want them as an 
        array of dictionaries/maps (so they can be used in Dart language, as I am automating my process) so 
        format the subtasks(with headings,descriptions, and deadlines) accordingly. And I dont want you to output anything else
        other than the array (dont think out loud, dont say "yes, certainly, ill do it" , just send the array of dictionaries 
        in output), so I can easily treat your answer as the array and deal with it accordingly. Ok so, now that my instructions are clear, 
        the heading of the idea is: $taskheading, description: $taskdesc Today is 5th March 2024, deadline of this project is $deadline. 
        And lastly, while writing the list of dictionaries, just write the list of dictionaries, and keep in
        mind that there will be 3 key value pairs in each dictionary, and the key names will be deadline, 
        content(which will describe the subtask), subheading(which will tell what that subtask is about) 
        dont declare it or initialise it as some variable, i will handle that part. Thank you !
    """;
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: 
      {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey' 
      },
      body: jsonEncode(
        {
        "model":"gpt-3.5-turbo-0125",
        'messages': [
          {'role': 'system', 'content': prompt},
        ]
      })
    );
    try{    
      if (response.statusCode == 200)    // if the response if OK then
       {
          final resp = response.body;
          final Map<String, dynamic> res = jsonDecode(resp);
          final String result = res['choices'][0]['message']["content"];    // extract the result result from the content
          dynamic data = jsonDecode(result);
          if (data is List) 
          {  
            List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(
                data.map((element) => Map<String, dynamic>.from(element)));
            return listOfMaps;
          }

      } 
      else 
      {
          showerrormsg(message: response.body);   //never reached this point
      }
    } 
    catch(e)
    {
        showerrormsg(message: e.toString());    //never reached this point
    }
    print("An Error Occured in the API Call");
    return [];
  }