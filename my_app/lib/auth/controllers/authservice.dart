// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/toast.dart';


class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registeracc(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      showerrormsg(message: "${e.message}");
    }
    return null;
  }

  Future<User?> loginacc(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      showerrormsg(message: "${e.message}");
    }
    return null;
  }
  
  Future<User?> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      showerrormsg(message: " user is not logged in ");
    }
    return null;
  }
}
