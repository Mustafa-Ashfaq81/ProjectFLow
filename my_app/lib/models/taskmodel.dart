import 'package:my_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String heading;
  String? status;
  String? duedate;
  String? duehour;
  List<Subtask> subtasks;

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
