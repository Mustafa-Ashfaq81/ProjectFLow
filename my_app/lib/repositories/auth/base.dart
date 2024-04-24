import 'package:flutter/material.dart';

class AppUser {
  final String email;
  final String username;

  AppUser({required this.email, required this.username});
}

class LoginProps {
  final String email;
  final String password;

  LoginProps({required this.email, required this.password});
}

class BaseAuthRepository {
  Future<AppUser?> login(LoginProps props) async {
    throw UnimplementedError();
  }

  loginWithGoogle(BuildContext context) async {
    throw UnimplementedError();
  }

  register() {
    throw UnimplementedError();
  }

  logout(BuildContext context) async {}

  signOutFromGoogle() {}
}
