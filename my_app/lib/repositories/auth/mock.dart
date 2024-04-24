import 'package:flutter/material.dart';
import 'package:my_app/repositories/auth/app.dart';
import 'package:my_app/repositories/auth/base.dart';

class MockedAuthRepository implements BaseAuthRepository {
  @override
  login(LoginProps props) async {
    if (props.email == 'eessa@gmail.com') {
      return AppUser(email: "eessa@gmail.com", username: "eessa");
    }
    throw AuthException("Invalid Email or password");
  }

  @override
  register() {}
  
  @override
  loginWithGoogle(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  logout(BuildContext context) {}

  @override
  signOutFromGoogle() {
    throw UnimplementedError();
  }
}
