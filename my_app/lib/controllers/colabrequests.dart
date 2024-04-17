// ignore_for_file: avoid_print,use_build_context_synchronously,non_constant_identifier_names, avoid_function_literals_in_foreach_calls
import 'package:flutter/material.dart';
import 'package:my_app/models/taskmodel.dart';
import 'package:my_app/models/groupchatmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/cache_util.dart';


/*

The files contains the implementation of collaboration requests. The user can accept or reject the requests
A request is sent when a new project is created and the user wants to collaborate with other users

*/



// Retrieves collaboration requests for a given username from a Fire snapshot

List<Map<String, dynamic>> getRequests(
    String username, QuerySnapshot snapshot) 
    {
  List<Map<String, dynamic>> reqs = snapshot.docs
      .where((doc) => (doc['req_recv'] as List<dynamic>).contains(username))
      .map((doc) => {
            'sender': doc['req_sender'],
            'task': doc['req_task'],
          })
      .toList();
  return reqs;
}

// Retrieves collaboration requests if any are pending for a user
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

// Accepts a collaboration request
Future<void> acceptreq(BuildContext context,Map<String, dynamic> task, String username) async {

  var updatedtask = await getSpecificTask(task);
  final userCollection = FirebaseFirestore.instance.collection("users");
  try {
    List<dynamic> colaborators = updatedtask['collaborators'];
    List<String> colabz = colaborators.cast<String>();
    colabz.add(username);
    updatedtask['collaborators'] = colabz; // add collaborator(this user who accepted request) to sender's task
    var snapshot =
        await userCollection.where('username', isEqualTo: task['sender']).get();
    var doc = snapshot.docs.first;
    List<dynamic> tasks = doc.data()['tasks'];
    tasks[task['index'] ?? task['task']] = updatedtask;
    await doc.reference.update({'tasks': tasks});

    snapshot =
        await userCollection.where('username', isEqualTo: username).get(); //add that task for user who accepted the colab request
    doc = snapshot.docs.first;
    tasks = doc.data()['tasks'];
    tasks.add(updatedtask);
    await doc.reference.update({'tasks': tasks});
    updateColabinDatabase(username, task);
    print("accepted-req-successfully");
    await updaterooms(task,username);   //update group chats and requests in cache
    await TaskService().updateCachedRequests(task,username);
  } 
  catch (e) 
  {
    print("accepting req err $e");
  }
}


// Rejects a collaboration request
Future<void> rejectreq(BuildContext context,Map<String, dynamic> task, String username) async 
{
  try 
  {
    updateColabinDatabase(username, task);
    await TaskService().updateCachedRequests(task,username);
  } 
  catch (error) 
  {
    print("Error rejecting reqst: $error");
  }
}


// Updates collaboration data in the Fire database
Future<void> updateColabinDatabase(String username, Map<String,dynamic> task) async
{
  try
  {
    await FirebaseFirestore.instance
          .collection('colab')
          .where('req_sender', isEqualTo: task['sender'])
          .where('req_task', isEqualTo: task['index'])
          .get()
          .then((querySnapshot) 
          {
        for (var doc in querySnapshot.docs) 
        {
          doc.reference.update(
          {
            'req_recv': FieldValue.arrayRemove([username])
          }).then((value) 
          {
            doc.reference.get().then((docSnapshot)  // Check if 'usernames' is now empty and delete the record
            {
              if (docSnapshot.get('req_recv').isEmpty) 
              {
                doc.reference.delete();
              }
            });
          });
        }
      });
  } 
  catch (e)
  {
    print("error at updating colab collection in db  $e");
  }
}