// ignore_for_file: avoid_print,use_build_context_synchronously,non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/views/colab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Widget showRequests( BuildContext context,  List<Map<String, dynamic>> requests, String username) {
  return requests.isEmpty
      ? const Padding(
          padding: EdgeInsets.only(
            top: 10.0,
          ),
          child: Center(child: Text("No requests for collaboration yet")))
      : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: requests
                  .map((task) => requests.indexOf(task) % 2 == 0
                      ? Container(
                          margin: const EdgeInsets.only(left: 10.0, top: 10.0),
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE16C00).withOpacity(0.48),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column( // Colums: for vertical alignment
                              children: [
                            Center(
                              child: Text(
                                task['heading']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              task['sender']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                acceptreq(context,task, username);
                              },
                              child: const Text("Accept request"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                rejectreq(context,task, username);
                              },
                              child: const Text("Decline request"),
                            )
                          ]))
                      : Container(
                          margin: const EdgeInsets.only(left: 10.0, top: 10.0),
                          height: 200.0,
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: const Color(0xFF141310),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(children: [
                            Center(
                              child: Text(
                                task['heading']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              task['sender']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                acceptreq(context,task, username);
                              },
                              child: const Text("Accept request"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                rejectreq(context,task, username);
                              },
                              child: const Text("Decline request"),
                            )
                          ])))
                  .toList(),
            ),
          ));
}

List<Map<String, dynamic>> getRequests(
    String username, QuerySnapshot snapshot) {
  List<Map<String, dynamic>> reqs = snapshot.docs
      .where((doc) => (doc['req_recv'] as List<dynamic>).contains(username))
      .map((doc) => {
            'sender': doc['req_sender'],
            'task': doc['req_task'],
          })
      .toList();
  return reqs;
}

Future<List<Map<String, dynamic>>> get_ifany_requests(
    String username, List<String> otherusers) async {
  List<Map<String, dynamic>> reqtasks = [];
  var snapshot = await FirebaseFirestore.instance.collection('colab').get();
  List<Map<String, dynamic>> reqs = getRequests(username, snapshot);
  for (var req in reqs) {
    var tsk = await getSpecificTask(req);
    reqtasks.add({
      'sender': req["sender"],
      'heading': tsk['heading'],
      "index": req['task']
    });
  }
  return reqtasks;
}

void acceptreq(BuildContext context,Map<String, dynamic> task, String username) async {

  var updatedtask = await getSpecificTask(task);
  final userCollection = FirebaseFirestore.instance.collection("users");
  try {
    List<dynamic> colaborators = updatedtask['collaborators'];
    List<String> colabz = colaborators.cast<String>();
    colabz.add(username);
    updatedtask['collaborators'] = colabz;
    //add collaborator(this user who accepted request) to sender's task
    var snapshot =
        await userCollection.where('username', isEqualTo: task['sender']).get();
    var doc = snapshot.docs.first;
    List<dynamic> tasks = doc.data()['tasks'];
    tasks[task['index']] = updatedtask;
    await doc.reference.update({'tasks': tasks});

    //add that task for user who accepted the colab request
    snapshot =
        await userCollection.where('username', isEqualTo: username).get();
    doc = snapshot.docs.first;
    tasks = doc.data()['tasks'];
    tasks.add(updatedtask);
    await doc.reference.update({'tasks': tasks});
    updateColabinDatabase(username, task);
    print("accepted-req-successfully");
    Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ColabPage(username: username),
              ));
    
  } catch (e) {
    print("accepting req err $e");
  }

}

void rejectreq(BuildContext context,Map<String, dynamic> task, String username) async {
  try {
    updateColabinDatabase(username, task);
    print("rejected-req-successfully");
    Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ColabPage(username: username),
              ));
  } catch (error) {
    print("Error rejecting reqst: $error");
  }
}


Future<void> updateColabinDatabase(String username, Map<String,dynamic> task) async{
  try{
    await FirebaseFirestore.instance
          .collection('colab')
          .where('req_sender', isEqualTo: task['sender'])
          .where('req_task', isEqualTo: task['index'])
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({
            'req_recv': FieldValue.arrayRemove([username])
          }).then((value) {
            // Check if 'usernames' is now empty and delete the record
            doc.reference.get().then((docSnapshot) {
              if (docSnapshot.get('req_recv').isEmpty) {
                doc.reference.delete();
              }
            });
          });
        }
      });
  } catch (e){
    print("error at updating colab collection in db  $e");
  }
}
