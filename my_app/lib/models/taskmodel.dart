import 'package:my_app/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String heading;
  final List<Subtask> subtasks;

  Task({
    required this.heading,
    required this.subtasks,
  });
}

class Subtask {
  final String subheading;
  final String content;

  Subtask({
    required this.subheading,
    required this.content,
  });
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
