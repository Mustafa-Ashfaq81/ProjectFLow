import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatModel {
  final String? room_id;
  final String? heading;
  List<String>? members;

  GroupChatModel({this.room_id, this.heading, this.members});

  factory GroupChatModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

      return GroupChatModel(
        room_id: data['room_id'],
        members: data['members'],
        heading: data['heading'],
      );
    
  }

  static GroupChatModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return GroupChatModel(
      heading: snapshot['heading'],
      members: snapshot['members'],
      room_id: snapshot['room_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"heading": heading, "members": members, "room_id": room_id};
  }
}

Future<void> updaterooms(Map<String, dynamic> task, String username) async {
  final taskcreator = task['sender'];
  final tasknum  = (task['index'] ?? task['task']).toString();
  final room_id = taskcreator + "#" + tasknum;
  // print("unique_room_id is $room_id ");
  
  var snapshot = await FirebaseFirestore.instance.collection('rooms').where('room_id', isEqualTo: room_id).get();
  final doc = snapshot.docs.first; //only one room with that id
  try{
     List<dynamic> members = doc.data()['members'];
     members.add(username);
     await doc.reference.update({'members': members});
  } catch(e){
    print("error : could not add member to room chat $e");
  }
}

Future<List<Map<String,dynamic>>> fetchroomsforuser(String username) async{
  final rooms = <Map<String, dynamic>>[]; 
  final snapshot = await FirebaseFirestore.instance.collection('rooms').get();

  try{
    for (final doc in snapshot.docs) {
      final roomData = doc.data() as Map<String, dynamic>; // Cast to Map
      final members = roomData['members'] as List<dynamic>?; // Cast and handle potential null

      // Add if username exists in the members array and room data is valid
      if (members != null && members.contains(username)) {
        rooms.add(roomData); 
      }
    }
    // print("got-rooms $rooms");

  } catch(e){
    print("err fetching rooms for user $e");
  }
  return rooms;
}