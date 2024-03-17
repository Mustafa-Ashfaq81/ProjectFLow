// ignore_for_file: avoid_print, non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String heading;
  String description;
  String? status;
  String? duedate;
  String? duehour;
  List<String> collaborators;
  List<Subtask> subtasks; //subtasks should also have status to show progress?

  Task({
    required this.description,
    required this.heading,
    required this.status,
    required this.duedate,
    required this.duehour,
    required this.collaborators,
    required this.subtasks,
  });

  Map<String, dynamic> toMap() => {
        'heading': heading,
        'status': status,
        'description': description,
        'duedate': duedate,
        'duehour': duehour,
        'collaborators': collaborators,
        'subtasks': subtasks.map((subtask) => subtask.toMap()).toList(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        heading: map['heading'] as String,
        duedate: map['duedate'] as String,
        duehour: map['duehour'] as String,
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

List<Map<String, dynamic>> maptasks(List<Task> tasks) {
  return tasks
      .map((task) => {
            'heading': task.heading,
            'duedate': task.duedate,
            'duehour': task.duehour,
            'status': task.status,
            'description': task.description,
            'collaborators': task.collaborators,
            'subtasks': task.subtasks
                .map((subtask) => {
                      'content': subtask.content,
                      'subheading': subtask.subheading,
                      'deadline' : subtask.deadline
                          .toString(), 
                    })
                .toList(),
          })
      .toList();
}

class Subtask {
  String subheading;
  String content;
  String deadline;

  Subtask({
    required this.subheading,
    required this.content,
    required this.deadline
  });

  Map<String, dynamic> toMap() => {
        'subheading': subheading,
        'content': content,
        'deadline':deadline,
      };

  factory Subtask.fromMap(Map<String, dynamic> map) => Subtask(
        subheading: map['subheading'] as String,
        content: map['content'] as String,
        deadline:map['deadline'] as String,
      );
}

Future<List<String>> getTaskHeadings(String username) async {
  QuerySnapshot<Map<String, dynamic>> users =
      await FirebaseFirestore.instance.collection('users').get();

  List<String> headings = [];

  for (var doc in users.docs) {
    if (doc.data()['username'] == username) {
      List tasks = doc.data()['tasks'];
      for (var item in tasks) {
        headings.add(item['heading']);
      }
      break; // Exiting the loop since we found the user
    }
  }
  return headings;
}

Future<List<dynamic>> getSubTasks(String username, String taskheading) async {
  Map<String, dynamic> task = await getTaskbyHeading(taskheading, username);
  return task["subtasks"];
}

Future<void> addSubTasks(String username, String taskheading, List<Map<String,dynamic>> subtasks) async {
 print("adding subtasks ");
 final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc =  snapshot.docs.first; 

  try {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == taskheading) {
        tasks[i]['subtasks'] = subtasks;
      }
    }
    await doc.reference.update({'tasks': tasks});
  } catch (e) {
    print("adding subtask err $e");
  }

  print("adding-subtask-done");
}

List<Object> getTasks(String username, QuerySnapshot snapshot) {
  List<Object> tasks =
      snapshot.docs.where((doc) => doc['username'] == username).map((doc) {
    final dynamic tsk = doc['tasks'];
    if (tsk is List<dynamic>) {
      return tsk;
    } else if (tsk is String) {
      return tsk;
    }
    return ''; // Fall back condition
  }).toList();

  return tasks;
}

Future<Map<String, dynamic>> getTaskbyHeading(String taskheading, String username) async{
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc =
      snapshot.docs.first; 
   List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == taskheading) {
        return tasks[i];
      }
    }
    return {};

}

Future<List<Map<String, dynamic>>> getAllTasks( String username) async{
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc =
      snapshot.docs.first; 
  List<dynamic> tasks = doc.data()['tasks'] ?? [];
  List<Map<String, dynamic>> taskmap = tasks.cast<Map<String, dynamic>>();
  return taskmap;

}

Future<Map<String, dynamic>> getSpecificTask(req) async {
  final alltasks = await FirebaseFirestore.instance.collection('users').get();
  List<dynamic> tasks = [];
  for (var doc in alltasks.docs) {
    if (doc.data()['username'] == req["sender"]) {
      tasks = doc.data()['tasks'];
    }
  }

  try {
    for (int i = 0; i < tasks.length; i++) {
      if ((tasks[i] is Map<String, dynamic>) && ((i == req['task']) || (i == req['index']) )) {
        return tasks[i];
      }
    }
  } catch (e) {
    print("err --- $e");
  }
  return {};
}

Future<int> getTaskindex(String heading, String username) async {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc =
      snapshot.docs.first; //since only there is one user with that username

  try {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == heading) {
        return i;
      }
    }
  } catch (e) {
    print("got er $e");
  }
  return -1;
}

Future<void> editTask(String username, String heading, String description, String originalheading) async {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc =
      snapshot.docs.first; 

  try {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == originalheading) {
        tasks[i]['heading'] = heading;
        tasks[i]['description'] = description;
      }
    }
    await doc.reference.update({'tasks': tasks});
  } catch (e) {
    print("editing task err $e");
  }

  print("editing-done");
}

Future<void> addTask(String username, String heading, String description,
    List<String> collaborators) async {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc = snapshot.docs.first;

  try {
    List<dynamic> tasks = doc.data()['tasks'];
    final Map<String,dynamic> newtask = {
        "heading": heading,
        "description": description,
        "status": "progress",
        "duedate": "",
        "duehour": "",
        "collaborators": [],
        "subtasks": []
    };
    tasks.add(newtask);
    await doc.reference.update({'tasks': tasks});
    if (collaborators.isEmpty == false) {
      sendColabreq(collaborators, heading, username);
    }
  } catch (e) {
    print("adding task err $e");
  }
}


Future<void> deleteTask(String username, String taskHeading) async {
  try {
    final userCollection = FirebaseFirestore.instance.collection("users");
    final snapshot = await userCollection.where('username', isEqualTo: username).get();
    final doc = snapshot.docs.first; 

    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    
    tasks.removeWhere((task) => task['heading'] == taskHeading);
    
    await doc.reference.update({'tasks': tasks});
    print("Task delete success");
  } catch (e) {
   print("task del err $e");
  }
}


List<Task> get_random_task() {
  // We hardcoded random tasks for testing purposes.
  return [
    Task(
        heading: "t_one",
        status: "completed",
        collaborators: [],
        description: "none",
        duedate: "",
        duehour: "",
        subtasks: []),
    Task(
        heading: "t_two",
        status: "progress",
        collaborators: [],
        description: "none2",
        duedate: "",
        duehour: "",
        subtasks: [Subtask(subheading: "sub_t2", content: "cont_t2", deadline: "")]),
    Task(
        heading: "t_three",
        status: "",
        duedate: "",
        duehour: "",
        collaborators: [],
        description: "none3",
        subtasks: [
          Subtask(subheading: "sub_t1", content: "cont_t1", deadline: ""),
          Subtask(subheading: "sub_t2", content: "cont_t2", deadline: "")
        ]),
    Task(
        heading: "t_5",
        status: "completed",
        collaborators: [],
        description: "no5ne",
        duedate: "",
        duehour: "",
        subtasks: []),
    Task(
        heading: "t_6",
        status: "completed",
        collaborators: [],
        description: "n6one",
        duedate: "",
        duehour: "",
        subtasks: []),
    Task(
        heading: "t_13",
        status: "progress",
        collaborators: [],
        description: "not13",
        duedate: "",
        duehour: "",
        subtasks: []),
    Task(
        heading: "t_49",
        status: "progress",
        collaborators: [],
        description: "not49",
        duedate: "",
        duehour: "",
        subtasks: [])
  ];
}

void sendColabreq(List<String> usernames, String heading, String sender) async {
  print('sending req...');
  try {
    final colabCollection = FirebaseFirestore.instance.collection('colab');
    final index = await getTaskindex(heading, sender);
    Map<String, dynamic> data = {
      'req_recv': usernames,
      'req_sender': sender,
      'req_task': index
    };
    print(data);
    await colabCollection.add(data);
    print('Colab req sent successfully.');
  } catch (e) {
    print('Error sending req: $e');
  }
}
