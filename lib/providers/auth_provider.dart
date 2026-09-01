import 'package:flutter/material.dart';
import '../models/passenger.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  Passenger? _passenger;
  bool _isLoading = false;

  Passenger? get passenger => _passenger ?? _authService.mockUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => passenger != null;

  AuthProvider() {
    _passenger = _authService.mockUser;
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _passenger = await _authService.signInWithEmailAndPassword(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String gender,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      _passenger = await _authService.registerUser(
        name: name,
        email: email,
        password: password,
        gender: gender,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePreferences({
    required bool safetyPreference,
    required String mobilityStatus,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.updatePreferences(
        safetyPreference: safetyPreference,
        mobilityStatus: mobilityStatus,
      );
      _passenger = _passenger?.copyWith(
        safetyPreference: safetyPreference,
        mobilityStatus: mobilityStatus,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _passenger = null;
    notifyListeners();
  }
}
