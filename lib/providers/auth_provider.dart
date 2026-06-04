import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_flutter/data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String _message = '';

  String get message => _message;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      _user = await _authService.login(email, password);
      _message = 'Login successful';
    } on FirebaseAuthException catch (e) {
      _user = null;
      _message = e.message ?? 'Invalid email or password';
    }
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    try {
      _user = await _authService.register(email, password);
      _message = 'Register successful';
    } on FirebaseAuthException catch (e) {
      _user = null;
      _message = e.message ?? 'Registration failed';
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
