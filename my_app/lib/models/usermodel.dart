// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/models/taskmodel.dart';

class UserModel {
  final String? username;
  final String? id;
  final String? email;
  List<Task>? tasks;

  UserModel({this.id, this.username, this.email, this.tasks});

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(
      username: snapshot['username'],
      email: snapshot['email'],
      tasks: snapshot['tasks'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"username": username, "email": email, "id": id, "tasks": tasks};
  }
}

Stream<List<UserModel>> readUser() {
  final userCollection = FirebaseFirestore.instance.collection("users");
  return userCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs
      .map(
        (e) => UserModel.fromSnapshot(e),
      )
      .toList());
}

void createUser(UserModel userModel) {
  final userCollection = FirebaseFirestore.instance.collection("users");
  String id = userCollection.doc().id;

  final newUser = UserModel(
    username: userModel.username,
    email: userModel.email,
    tasks: userModel.tasks,
    id: id,
  ).toJson();

  userCollection.doc(id).set(newUser);
}

void updateUserData(UserModel userModel) {
  final userCollection = FirebaseFirestore.instance.collection("users");

  final newData = UserModel(
    username: userModel.username,
    email: userModel.email,
    tasks: userModel.tasks,
    id: userModel.id,
  ).toJson();

  userCollection.doc(userModel.id).update(newData);
}

void deleteUserData(String id) {
  final userCollection = FirebaseFirestore.instance.collection("users");
  userCollection.doc(id).delete();
}
