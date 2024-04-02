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
    try {
      // Cache the fetched tasks data for quick access later
      List<Map<String, dynamic>> tasks = await getAllTasks(username);
      print("all-tasks-fetched");

      List<Map<String, dynamic>> allTasks = [];
      List<Map<String, dynamic>> completedProjects = [];
      List<Map<String, dynamic>> ongoingProjects = [];
      List<Map<String, dynamic>> deadlines = [];
      List<String> headings = [];

      for(var task in tasks){
        allTasks.add({
          'heading':task['heading'],
          'description':task['description'],
          'status' :task['status']
        });
        Map<String,String> deadline = {
          'heading' : task['heading'],
          'duedate': task['duedate'],
          'start_time': task['start_time'],
          'end_time': task['end_time'],
        };
        if(deadline['start_time'] != "" && deadline['end_time'] != "" ) {
          deadlines.add(deadline);
        }
     }

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

      CacheUtil.cacheData('tasks_$username', allTasks.reversed.toList());
      CacheUtil.cacheData('ongoingProjects_$username', ongoingProjects.reversed.toList());
      CacheUtil.cacheData('completedProjects_$username', completedProjects.reversed.toList());
      CacheUtil.cacheData('headings_$username', headings);
      CacheUtil.cacheData('deadlines_$username', deadlines);
      print("notes,deadlines,headings,status-wise tasks HAVE BEEN fetched ... ");

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
}