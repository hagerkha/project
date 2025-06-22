import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_apple_sign_in/scope.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _repository;
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(this._repository);

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getCurrentUser() async {
    _isLoading = true;
    notifyListeners();
    _currentUser = await _repository.getCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.signInWithGoogle();
      _currentUser = await _repository.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithApple({List<Scope> scopes = const []}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.signInWithApple(scopes: scopes);
      _currentUser = await _repository.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.signInWithEmailAndPassword(email, password);
      _currentUser = await _repository.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.createUserWithEmailAndPassword(email, password, name);
      _currentUser = await _repository.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.sendPasswordResetEmail(email);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _repository.signOut();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }
}