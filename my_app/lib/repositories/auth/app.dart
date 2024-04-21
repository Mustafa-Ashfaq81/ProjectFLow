import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/repositories/auth/base.dart';
import 'package:my_app/utils/cache_util.dart';

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}

class AuthRepository implements BaseAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<AppUser> login(LoginProps props) async {
    String username = "";
    String email = props.email;
    String password = props.password;

    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        username = doc['username'];
      }
    });

    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    if (credential.user != null) {
      await TaskService().fetchAndCacheNotesData(username);
      await TaskService().fetchAndCacheColabRequests(username);
    }

    return AppUser(
      email: email,
      username: username,
    );
  }

  @override
  register() {}
}
