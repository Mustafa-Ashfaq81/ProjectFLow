// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/models/taskmodel.dart';

class CacheUtil {
  static final Map<String, dynamic> _cache = {};

  static void cacheData(String key, dynamic data) {
    _cache[key] = data;
  }

  static dynamic getData(String key) 
  {
    if (_cache.containsKey(key)) {
      return _cache[key];
    } else {
      return null;
    }
  }

  static bool hasData(String key) {
    return _cache.containsKey(key);
  }

  static void removeData(String key) {
    _cache.remove(key);
  }
}


class TaskService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> fetchAndCacheNotesData(String username) async {
    // var snapshot = await firestore.collection('users').get();
    // List<Object> tasks =
    //     snapshot.docs.where((doc) => doc['username'] == username).map((doc) {
    //       final dynamic tsk = doc['tasks'];
    //       return tsk is List<dynamic> ? tsk : [];
    // }).toList();

    // List<Map<String, dynamic>> allTasks = [];
    // tasks.forEach((taskList) {
    //   List<dynamic> itemList = taskList as List<dynamic>;
    //   itemList.forEach((item) {
    //     Map<String, dynamic> taskMap = item as Map<String, dynamic>;
    //     allTasks.add({
    //       'heading': taskMap['heading'],
    //       'description': taskMap['description'],
    //       'status': taskMap['status'],
    //     });
    //   });
    // });

    try {
      // Cache the fetched tasks data for quick access later
      List<Map<String, dynamic>> tasks = await getAllTasks(username);
      print("all-tasks-fetched");

      List<Map<String, dynamic>> allTasks = [];
      List<Map<String, dynamic>> completedProjects = [];
      List<Map<String, dynamic>> ongoingProjects = [];
      List<String> headings = [];

      for(var task in tasks){
        allTasks.add({'heading':task['heading'],
        'description':task['description'],
        'status' :task['status']
        });
      }

      // for (var task in allTasks) { print(task);}
      CacheUtil.cacheData('tasks_$username', allTasks.reversed.toList());


      for (var task in allTasks) {
        String status = task["status"];
        if (status == "completed") {
          completedProjects.add(task);
        } else if (status == "progress") { 
          ongoingProjects.add(task);
        }
        String heading = task['heading'];
        headings.add(heading);
      }
      CacheUtil.cacheData('ongoingProjects_$username', ongoingProjects.reversed.toList());
      CacheUtil.cacheData('completedProjects_$username', completedProjects.reversed.toList());
      CacheUtil.cacheData('headings_$username', headings);
    } catch (e) {
      print("got error while caching $e");
    }
  } 

  Future<void> fetchAndCacheColabRequests(String username) async {
    List<Map<String, dynamic>> colabRequests = [];
    var snapshot = await FirebaseFirestore.instance.collection('colab').get();

    snapshot.docs.forEach((doc) {
      if ((doc.data()['req_recv'] as List<dynamic>).contains(username)) {
        colabRequests.add({
          'sender': doc.data()['req_sender'],
          'task': doc.data()['req_task'],
        });
      }
    });

    // Cache the fetched colab requests for quick access later
    CacheUtil.cacheData('colabRequests_$username', colabRequests);
  }
  // Future<void> fetchAndCacheOngoingProject(String username) async {
  //   print("Fetching Ongoing Projects");
  //   var snapshot = await FirebaseFirestore.instance.collection('users').get();
  //   List<Map<String, dynamic>> ongoingProjects = [];

  //   for (var doc in snapshot.docs.where((doc) => doc['username'] == username)) {
  //     List<dynamic> tasksList = doc['tasks'] ?? [];
  //     for (var task in tasksList) {
  //       Map<String, dynamic> taskMap = task as Map<String, dynamic>;
  //       if (taskMap['status'] == 'ongoing') {
  //         ongoingProjects.add({
  //           'heading': taskMap['heading'],
  //           'description': taskMap['description'],
  //           'status': taskMap['status'],
  //         });
  //       }
  //     }
  //   }

  //   CacheUtil.cacheData('ongoingProjects_$username', ongoingProjects);
  // }

//   Future<void> fetchAndCacheCompletedProject(String username) async {
//     print("Fetching Completed Projects");
//     var snapshot = await FirebaseFirestore.instance.collection('users').get();
//     List<Map<String, dynamic>> completedProjects = [];

//     for (var doc in snapshot.docs.where((doc) => doc['username'] == username)) {
//       List<dynamic> tasksList = doc['tasks'] ?? [];
//       for (var task in tasksList) {
//         Map<String, dynamic> taskMap = task as Map<String, dynamic>;
//         if (taskMap['status'] == 'completed') {
//           completedProjects.add({
//             'heading': taskMap['heading'],
//             'description': taskMap['description'],
//             'status': taskMap['status'],
//           });
//         }
//       }
//     }
//     CacheUtil.cacheData('completedProjects_$username', completedProjects);
//   }
}