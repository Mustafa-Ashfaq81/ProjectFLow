// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/utils/inappmsgs_util.dart';

/*

  This file manages user data interactions with Firebase Firestore and Firebase Authentication.
  It includes the UserModel class for data structure, and functions for creating, reading, updating,
  and deleting user data. Additional functionalities include email and password updates with user re-authentication

*/

class UserModel  // Represents a user with their relevant details and tasks.
{
  final String? username;
  final String? id;
  final String? email;
  List<Map<String, dynamic>>? tasks;

  UserModel({this.id, this.username, this.email, this.tasks});

    // Constructs a UserModel from a Firestore document snapshot

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) 
  {
    final data = snapshot.data()!;
    final tasksMap = data['tasks'] as List<Map<String, dynamic>>?;

    if (tasksMap != null) 
    {

      return UserModel(
        id: snapshot.id,
        email: data['email'],
        username: data['username'],
        tasks: tasksMap,
      );
    } else {
      return UserModel(
        id: snapshot.id,
        email: data['email'],
        username: data['username'],
        tasks: [],
      );
    }
  }

  static UserModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) 
  {
    return UserModel(
      username: snapshot['username'],
      email: snapshot['email'],
      tasks: snapshot['tasks'],
      id: snapshot['id'],
    );
  }

  Map<String, dynamic> toJson() 
  {
    return {"username": username, "email": email, "id": id, "tasks": tasks};
  }
}

// Stream of UserModel list, watching for changes in Firestore 'users' collection

Stream<List<UserModel>> readUser() 
{
  final userCollection = FirebaseFirestore.instance.collection("users");
  return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs
      .map(
        (e) => UserModel.fromSnapshot(e),
      )
      .toList());
}

Future<List<String>> getallUsers() async 
{
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("users").get();
  // Here we extract names from User objects instead of returning the User objects themselves
  return snapshot.docs.map((doc) => doc['username'] as String).toList();
}

Future<List<String>> getallEmails() async 
{
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("users").get();
  // Here we extract emails from User objects instead of returning the User objects themselves
  return snapshot.docs.map((doc) => doc['email'] as String).toList();
}

void createUser(UserModel userModel) 
{
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

void deleteUserData(String username) async 
{
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc = snapshot.docs.first;
  try 
  {
    doc.reference.delete();
  } 
  catch (e) 
  {
    print("err deleting data  ... $e");
  }
}


Future<String> updateUsername(String original_username,name, BuildContext context) async   // wont be used most probably as changing username would mean changing a lot of things
{ 
  var allusernames = await getallUsers();
  if (allusernames.contains(name) == true) 
  {
    // showerrormsg(message: "This username has been taken already");
    showCustomError("This username has been taken already", context);
    return original_username;
  } 

  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: original_username).get();
  final doc = snapshot.docs.first;
  await doc.reference.update({'username': name});
  showmsg(message: "Username has been updated successfully");
  return name;
}

Future<void> updateUserInfo(
    String original_username,
    String email,
    String oldPassword,
    String newPassword,
    bool emailChanged,
    bool passwordChanged,
    BuildContext context) async 
{
  if (emailChanged) 
  {
    try 
    {
      final userCollection = FirebaseFirestore.instance.collection("users");
      final snapshot = await userCollection
          .where('username', isEqualTo: original_username)
          .get();
      final doc = snapshot.docs.first;
      await doc.reference.update({'email': email});
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) 
      {
        await user.verifyBeforeUpdateEmail(
            email); //email addresses should be verified
      }
      showmsg(message: "Email has been updated successfully");
    } 
    catch (e) 
    {
      print("got error updating EMAIL ...  $e");
      // showerrormsg(
      //     message:
      //         "MUST verify on new email address before updating the email");
      showCustomError( "MUST verify on new email address before updating the email", context);
    }
  }

  if (passwordChanged) 
  {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) 
    {
      try 
      {
        // Reauthenticate the user with the old password
        final credential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);
        showmsg(message: "Password has been changed successfully");
      } 
      catch (e) 
      {
        print("got error updating password ...  $e");
        if (e is FirebaseAuthException && e.code == 'wrong-password') 
        {
          // showerrormsg(message: "The old password is incorrect");
          showCustomError("The old password is incorrect", context);
        } 
        else 
        {
          // showerrormsg(message: "Please ensure you are entering the correct password");
          showCustomError("Please ensure you are entering the correct password", context);
        }
      }
    }
  }

  return;
}

