import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../common/toast.dart';

import 'package:my_app/controllers/taskstatus.dart';

import '../../controllers/colabrequests.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      if (credential.user != null) {
        String username = email.split('@')[0];
        await TaskService().fetchAndCacheNotesData(username);
        await TaskService().fetchAndCacheOngoingProject(username);
        await TaskService().fetchAndCacheCompletedProject(username);
        await fetchAndCacheColabRequests(username);


      }

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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              clientId:
                  "12273615091-8aa1ois5l7b31tmirhcp6p7lihgmh1hk.apps.googleusercontent.com")
          .signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      showerrormsg(message: "Some error occured with Google Sign In Api");
      return null;
    }
  }
}
