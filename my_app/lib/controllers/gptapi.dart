import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/common/toast.dart';


Future<List<Map<String,dynamic>>> gptapicall(String taskheading, String taskdesc) async{

    const String apiKey = "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";
    // const String heading = "Autonomous self driving robot";
    // const String description = """
    //     I want to create a self driving model / prototype on a DJI ROBOMASTER model, with 4 tyres, 
    //     it would be using a camera, and sensors, it should be able to do good lane detection, obstacle avoidance, 
    //     as well as go-to-goal behaviour,  it should be able to map its environment, and do other required things as well.
    // """;
    const String deadline = "15th May 2024";
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
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey' 
      },
      body: jsonEncode({
        "model":"gpt-3.5-turbo-0125",
        'messages': [
          {'role': 'system', 'content': prompt},
        ]
      })
    );
    try{
      if (response.statusCode == 200) {
          final resp = response.body;
          // print("response ... $resp");
          final Map<String, dynamic> res = jsonDecode(resp);
          final String result = res['choices'][0]['message']["content"];
          // print("response ... $result");
          dynamic data = jsonDecode(result);
          if (data is List) {  //  if data is a List
            // Cast each element to Map<String, dynamic>
            List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(
                data.map((element) => Map<String, dynamic>.from(element)));
            // for (var dictionary in listOfMaps) { print(dictionary); }
            return listOfMaps;
          }

      } else {
          showerrormsg(message: response.body);  
      }
    } catch(e){
        showerrormsg(message: e.toString());
    }
    print("some-issue-occured-in-api-call");
    return [];
  }