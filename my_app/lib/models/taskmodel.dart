import 'package:my_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String heading;
  String? status;
  String? duedate;
  String? duehour;
  //array of usernames of collaborating members of this task (except my username)
  List<Subtask> subtasks; //subtasks should also have status to show progress?

  Task({
    required this.heading,
    required this.status,
    required this.duedate,
    required this.duehour,
    required this.subtasks,
  });

  Map<String, dynamic> toMap() => {
        'heading': heading,
        'subtasks': subtasks.map((subtask) => subtask.toMap()).toList(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        heading: map['heading'] as String,
        duedate: map['duedate'] as String,
        duehour: map['duehour'] as String,
        status: map['status'] as String,
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
            'subtasks': task.subtasks
                .map((subtask) => {
                      'content': subtask.content,
                      'subheading': subtask.subheading
                          .toString(), // Assuming DateTime or similar
                    })
                .toList(),
          })
      .toList();
}

class Subtask {
  String subheading;
  String content;

  Subtask({
    required this.subheading,
    required this.content,
  });

  Map<String, dynamic> toMap() => {
        'subheading': subheading,
        'content': content,
      };

  factory Subtask.fromMap(Map<String, dynamic> map) => Subtask(
        subheading: map['subheading'] as String,
        content: map['content'] as String,
      );
}

void updateTask(UserModel userModel) {
  final userCollection = FirebaseFirestore.instance.collection("users");

  final newData = UserModel(
    username: userModel.username,
    email: userModel.email,
    tasks: userModel.tasks,
    id: userModel.id,
  ).toJson();

  userCollection.doc(userModel.id).update(newData);
}

Future<List<String>> getTaskHeadings(String username) async {
  print("get-headings");
  QuerySnapshot<Map<String, dynamic>> users =
      await FirebaseFirestore.instance.collection('users').get();

  List<String> headings = [];

  for (var doc in users.docs) {
    if (doc.data()['username'] == username) {
      List tasks = doc.data()['tasks'];
      for (var item in tasks) {
        headings.add(item['heading']);
      }
      break; // Exit the loop since we found the user
    }
  }
  print("got-headings");
  return headings;
}

List<Task> get_rand_task() {
  //hardcoded random tasks for testing purposes
  return [
    Task(
        heading: "t_one",
        status: "completed",
        duedate: "",
        duehour: "",
        subtasks: []),
    Task(
        heading: "t_two",
        status: "progress",
        duedate: "",
        duehour: "",
        subtasks: [Subtask(subheading: "sub_t2", content: "cont_t2")]),
    Task(heading: "t_three", status: "", duedate: "", duehour: "", subtasks: [
      Subtask(subheading: "sub_t1", content: "cont_t1"),
      Subtask(subheading: "sub_t2", content: "cont_t2")
    ]),
    Task(
        heading: "t_5",
        status: "completed",
        duedate: "",
        duehour: "",
        subtasks: []),
    Task(
        heading: "t_6",
        status: "completed",
        duedate: "",
        duehour: "",
        subtasks: []),
    Task(
        heading: "t_13",
        status: "progress",
        duedate: "",
        duehour: "",
        subtasks: []),
    Task(
        heading: "t_49",
        status: "progress",
        duedate: "",
        duehour: "",
        subtasks: [])
  ];
}

void editTask(String username, String heading) async {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc =
      snapshot.docs.first; //since only there is one user with that username

  try {
    List<dynamic> tasks = doc.data()['tasks'] ?? [];
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] is Map<String, dynamic> && tasks[i]['heading'] == heading) {
        tasks[i]['status'] = "latest-status";
        for (int j = 0; j < tasks[i]['subtasks'].length; j++) {
          tasks[i]['subtasks'][j]['content'] = 'lat-3-est-contnet';
        }
      }
    }
    await doc.reference.update({'tasks': tasks});
  } catch (e) {
    print("editing task err $e");
  }

  print("editing-done");
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
    return ''; // Return empty string as fallback
  }).toList();

  return tasks;
}

Future<String> getSpecificTask(req) async {
  final alltasks = await FirebaseFirestore.instance.collection('users').get();
  List<dynamic> tasks = [];
  for (var doc in alltasks.docs) {
    if (doc.data()['username'] == req["sender"]) {
      tasks = doc.data()['tasks'];
    }
  }

  try {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i] is Map<String, dynamic> && i == req['task']) {
        // print("ret tsk");
        return tasks[i]['heading'];
      }
    }
  } catch (e) {
    print("err --- $e");
  }
  return "";
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

void addTask(String username) async {}

void deleteTask(String username) async {}
