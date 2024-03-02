import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:my_app/models/taskmodel.dart';

class UserModel {
  final String? username;
  final String? id;
  final String? email;
  List<Map<String, dynamic>>? tasks;
  //settings as a separate class or maybe directly here

  UserModel({this.id, this.username, this.email, this.tasks});

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final tasksMap = data['tasks'] as List<Map<String, dynamic>>?;

    if (tasksMap != null) {
      // final tasks =
      //     tasksMap.map((taskData) => MapEntry(Task.fromMap(taskData))).toList();
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
  return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs
      .map(
        (e) => UserModel.fromSnapshot(e),
      )
      .toList());
}

Future<List<String>> getallUsers() async {
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection("users").get();
  // Extract names from User objects instead of returning the User objects themselves
  return snapshot.docs.map((doc) => doc['username'] as String).toList();
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

void deleteUserData(String username) async {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final snapshot =
      await userCollection.where('username', isEqualTo: username).get();
  final doc = snapshot.docs.first;
  try {
    doc.reference.delete();
  } catch (e) {
    print("err deleting data  ... $e");
  }
}
