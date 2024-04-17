// ignore_for_file: avoid_print, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';


/*

  This file defines the Task and Subtask models and contains methods to manage tasks within Firestore.

  It includes functionality for:
  - Creating, updating, and deleting tasks and subtasks
  - Fetching tasks and subtasks for specific users
  - Managing task collaboration requests.

  The interactions are handled via Firestore database operations

*/

class Task  // Represents a single task with subtasks and collaboration details.
{
  String heading;
  String description;
  String? status; // we only assumes 2 values: in-progress OR completed
  String? duedate;
  String? start_time;
  String? end_time;
  List<String> collaborators;
  List<Subtask> subtasks; //subtasks should also have status to show progress

  Task(
  {
    required this.description,
    required this.heading,
    required this.status,
    required this.duedate,
    required this.start_time,
    required this.end_time,
    required this.collaborators,
    required this.subtasks,
  });

    // Converts the Task instance into a map for Firestore storage.
  Map<String, dynamic> toMap() => 
      {
        'heading': heading,
        'status': status,
        'description': description,
        'duedate': duedate,
        'start_time': start_time,
        'end_time': end_time,
        'collaborators': collaborators,
        'subtasks': subtasks.map((subtask) => subtask.toMap()).toList(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        heading: map['heading'] as String,
        duedate: map['duedate'] as String,
        start_time: map['start_time'] as String,
        end_time: map['end_time'] as String,
        status: map['status'] as String,
        collaborators: map['collaborators'] as List<String>,
        description: map['description'] as String,
        subtasks: (map['subtasks'] as List<dynamic>?)
                ?.map((subtaskMap) =>
                    Subtask.fromMap(subtaskMap as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

List<Map<String, dynamic>> maptasks(List<Task> tasks) 
{
  return tasks
      .map((task) => {
            'heading': task.heading,
            'duedate': task.duedate,
            'start_time': task.start_time,
            'end_time': task.end_time,
            'status': task.status,
            'description': task.description,
            'collaborators': task.collaborators,
            'subtasks': task.subtasks
                .map((subtask) => 
                    {
                      'content': subtask.content,
                      'subheading': subtask.subheading,
                      'deadline' : subtask.deadline,
                      'progress' : subtask.progress
                          .toString(), 
                    })
                .toList(),
          })
      .toList();
}

class Subtask 
{
  String subheading;
  String content;
  String deadline;
  String progress; //Simily we only assumes 2 values: in-progress OR completed

  Subtask(
  {
    required this.subheading,
    required this.content,
    required this.deadline,
    required this.progress
  });

  Map<String, dynamic> toMap() => 
      {
        'subheading': subheading,
        'content': content,
        'deadline':deadline,
        'progress':progress,
      };

  factory Subtask.fromMap(Map<String, dynamic> map) => Subtask(
        subheading: map['subheading'] as String,
        content: map['content'] as String,
        deadline: map['deadline'] as String,
        progress: map['progress'] as String,
      );
}

Future<dynamic> getDoc(String username) async
{
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
        await userCollection.where('username', isEqualTo: username).get();
  return snapshot.docs.first;
}

Future<List<String>> getTaskHeadings(String username) async 
{
  QuerySnapshot<Map<String, dynamic>> users =
      await FirebaseFirestore.instance.collection('users').get();

  List<String> headings = [];

  for (var doc in users.docs) 
  {
    if (doc.data()['username'] == username) 
    {
      List tasks = doc.data()['tasks'];
      for (var item in tasks) 
      {
        headings.add(item['heading']);
      }
      break; // Exiting the loop since we found the user
    }
  }
  return headings;
}

Future<List<dynamic>> getSubTasks(String username, String taskheading) async 
{
  Map<String, dynamic> task = await getTaskbyHeading(taskheading, username);
  return task["subtasks"];
}

Future<void> addSubTasks(String username, String taskheading, List<Map<String,dynamic>> subtasks) async 
{
 print("adding subtasks ");
 final doc = await getDoc(username); 

  try 
  {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (var subtask in subtasks) {  subtask['progress'] = 'progress';  }  //setting progress for all created subtasks
    for (int i = 0; i < tasks.length; i++) 
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == taskheading) 
      {
        tasks[i]['subtasks'] = subtasks;
      }
    }
    await doc.reference.update({'tasks': tasks});
  } 
  catch (e)
  {
    print("adding subtask err $e");
  }

  print("adding-subtask-done");
}

List<Object> getTasks(String username, QuerySnapshot snapshot) 
{
  List<Object> tasks =
      snapshot.docs.where((doc) => doc['username'] == username).map((doc) 
  {
    final dynamic tsk = doc['tasks'];
    if (tsk is List<dynamic>) 
    {
      return tsk;
    } else if (tsk is String) 
    {
      return tsk;
    }
    return ''; // Fall back condition
  }).toList();

  return tasks;
}

Future<void> completeSubtask(String username, String heading,  String subtaskheading) async{
  final doc = await getDoc(username); 
  try {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) 
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == heading) 
      {
      for (int j=0; j<tasks[i]['subtasks'].length; j++)
      {
            if(tasks[i]['subtasks'][j]['subheading'] == subtaskheading)
            {
                tasks[i]['subtasks'][j]['progress'] = "completed";
                await doc.reference.update({'tasks': tasks});
                return;
            }
        }
      }
    }
  } catch (e) 
  {
    print("got er completing subtask $e");
  }


} 

Future<bool> isCompleted( String username, String heading) async
{  
  final doc = await getDoc(username); 
  try {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) 
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == heading) 
      {
       for (int j=0; j<tasks[i]['subtasks'].length; j++)
       {
            if(tasks[i]['subtasks'][j]['progress'] != 'completed')
            { 
              return false;
            }
       }
        tasks[i]['status'] = 'completed';
        await doc.reference.update({'tasks': tasks});
        return true;
      }
    }
  } catch (e) 
  {
    print("got er completing task $e");
  }
  print("un-reachable-point");
  return true;


}

Future<Map<String, dynamic>> getTaskbyHeading(String taskheading, String username) async
{
  final doc = await getDoc(username); 
   List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) 
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == taskheading) 
      {
        return tasks[i];
      }
    }
    return {};

}

Future<List<Map<String, dynamic>>> getAllTasks( String username) async
{
  try
  {
    final doc = await getDoc(username); 
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    List<Map<String, dynamic>> taskmap = tasks.cast<Map<String, dynamic>>();
    return taskmap;
  } 
  catch(e)
  {
    print("getting all tasks err ... $e");
    return [];
  }

}

Future<Map<String, dynamic>> getSpecificTask(req) async 
{
  final alltasks = await FirebaseFirestore.instance.collection('users').get();
  List<dynamic> tasks = [];
  for (var doc in alltasks.docs) 
  {
    if (doc.data()['username'] == req["sender"]) 
    {
      tasks = doc.data()['tasks'];
    }
  }

  try 
  {
    for (int i = 0; i < tasks.length; i++) 
    {
      if ((tasks[i] is Map<String, dynamic>) && ((i == req['task']) || (i == req['index']) )) 
      {
        return tasks[i];
      }
    }
  } 
  catch (e) 
  {
    print("err --- $e");
  }
  return {};
}

Future<int> getTaskindex(String heading, String username) async 
{
  final doc = await getDoc(username); 

  try 
  {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++)
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == heading) 
      {
        return i;
      }
    }
  } 
  catch (e) 
  {
    print("got er $e");
  }
  return -1;
}

Future<void> editTask(String username, String heading, String description, String originalheading) async 
{
  final doc = await getDoc(username); 

  try 
  {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) 
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == originalheading) 
      {
        tasks[i]['heading'] = heading;
        tasks[i]['description'] = description;
      }
    }
    await doc.reference.update({'tasks': tasks});
  } 
  catch (e) 
  {
    print("editing task err $e");
  }

  print("editing-done");
}

Future<void> addTask(String username, String heading, String description,
    List<String> collaborators, String date, String start_time, String end_time) async 
{
 final doc = await getDoc(username); 

  try 
  {
    List<dynamic> tasks = doc.data()['tasks'];
    final Map<String,dynamic> newtask = 
    {
        "heading": heading,
        "description": description,
        "duedate": date,
        "start_time": start_time,
        "end_time": end_time,
        "status": "progress",
        "collaborators": [],
        "subtasks": []
    };
    tasks.add(newtask);
    await doc.reference.update({'tasks': tasks});
    if (collaborators.isEmpty == false) 
    {
      sendColabreq(collaborators, heading, username);
       final tasknum  = (tasks.length-1).toString();
       final room_id = "$username#$tasknum"; //users can not add # to their username if we will split on # later
       await FirebaseFirestore.instance.collection('rooms').add({'room_id':room_id,'heading':heading,'members':[username]});
    }
  } catch (e) 
  {
    print("adding task err $e");
  }
}


Future<void> deleteTask(String username, String taskHeading) async 
{
  try {
    final doc = await getDoc(username); 
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    tasks.removeWhere((task) => task['heading'] == taskHeading);
    await doc.reference.update({'tasks': tasks});
    print("Task delete success");
  } 
  catch (e) 
  {
   print("task del err $e");
  }
}

Future<void> deleteSubTask(String username, String taskheading, String subTaskheading) async 
{
  try 
  {
    final doc = await getDoc(username); 
    List<dynamic> newtasks = [];
    List<dynamic> tasks = doc.data()['tasks'] ?? [];

    for (int i = 0; i < tasks.length; i++) 
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == taskheading) 
      {
        List<dynamic> updatedsubtasks = [];
        for (int j=0; j<tasks[i]['subtasks'].length; j++)
        {
            if(tasks[i]['subtasks'][j]['subheading'] == subTaskheading)
            {
                print("removing subtask now ..... ");
            } 
            else 
            {
              updatedsubtasks.add(tasks[i]['subtasks'][j]);
            }
        }
        dynamic updatedtask = tasks[i];
        updatedtask['subtasks'] = updatedsubtasks;
        newtasks.add(updatedtask);
      } 
      else 
      {
        newtasks.add(tasks[i]);
      }

    }
    
    await doc.reference.update({'tasks': newtasks});
  } 
  catch (e) 
  {
   print("subtask del err $e");
  }
}

Future<void> editSubTask(String username, String subheading, String content, String originalsubtaskheading, String taskheading) async {
  final doc = await getDoc(username); 

  try 
  {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) 
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == taskheading) 
      {
        for (int j=0; j<tasks[i]['subtasks'].length; j++)
        {
            if(tasks[i]['subtasks'][j]['subheading'] == originalsubtaskheading)
            {
                tasks[i]['subtasks'][j]['subheading'] = subheading;
                tasks[i]['subtasks'][j]['content'] = content;
                return;
            }
        }
      }
    }
    await doc.reference.update({'tasks': tasks});
  } 
  catch (e) 
  {
    print("editing subtask err $e");
  }
}

Future<List<Map<String,dynamic>>> getdeadlines(String username) async
{
  final doc = await getDoc(username); 
  try
  {
    List<Map<String,String>> deadlines = [];
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) 
    {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['duedate'] != "") 
      {
        Map<String,String> deadline = 
        {
          'heading' : tasks[i]['heading'],
          'duedate': tasks[i]['duedate'],
          'start_time': tasks[i]['start_time'],
          'end_time': tasks[i]['end_time'],
        };
        if(deadline['start_time'] != "" && deadline['end_time'] != "" ) 
        {
          deadlines.add(deadline);
        }
      }
    }
    return deadlines;
  } 
  catch(e)
  {
    print("get deadlines err $e");
  }
  return [];
}

List<Task> get_random_task() 
{
  return [
    Task(
        heading: "t_one",
        status: "completed",
        collaborators: [],
        description: "none",
        duedate: "",
        start_time: "",
        end_time: "",
        subtasks: []),
    Task(
        heading: "t_two",
        status: "progress",
        collaborators: [],
        description: "none2",
        duedate: "",
        start_time: "",
        end_time: "",
        subtasks: [Subtask(subheading: "sub_t2", content: "cont_t2", deadline: "", progress:"progress")]),
    Task(
        heading: "t_three",
        status: "completed",
        duedate: "",
        start_time: "",
        end_time: "",
        collaborators: [],
        description: "none3",
        subtasks: [
          Subtask(subheading: "sub_t1", content: "cont_t1", deadline: "",progress:"completed"),
          Subtask(subheading: "sub_t2", content: "cont_t2", deadline: "",progress:"progress")
        ]),
    Task(
        heading: "t_5",
        status: "completed",
        collaborators: [],
        description: "no5ne",
        duedate: "",
        start_time: "",
        end_time: "",
        subtasks: []),
    Task(
        heading: "t_6",
        status: "completed",
        collaborators: [],
        description: "n6one",
        duedate: "",
        start_time: "",
        end_time: "",
        subtasks: []),
    Task(
        heading: "t_13",
        status: "progress",
        collaborators: [],
        description: "not13",
        duedate: "",
        start_time: "",
        end_time: "",
        subtasks: []),
    Task(
        heading: "t_49",
        status: "progress",
        collaborators: [],
        description: "not49",
        duedate: "",
        start_time: "",
        end_time: "",
        subtasks: [])
  ];
}

void sendColabreq(List<String> usernames, String heading, String sender) async 
{
  print('sending req...');
  try 
  {
    final colabCollection = FirebaseFirestore.instance.collection('colab');
    final index = await getTaskindex(heading, sender);
    Map<String, dynamic> data = 
    {
      'req_recv': usernames,
      'req_sender': sender,
      'req_task': index
    };
    await colabCollection.add(data);
    print('Colab req sent successfully.');
  } 
  catch (e) 
  {
    print('Error sending req: $e');
  }
}
