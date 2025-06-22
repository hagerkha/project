import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../data_source/auth_data_source.dart';
import '../model/user_model.dart';

class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<User?> getCurrentUser() async {
    return await _dataSource.getCurrentUser();
  }

  Future<void> signInWithGoogle() async {
    final user = await _dataSource.signInWithGoogle();
    if (user != null) await _dataSource.addUser(user);
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    final user = await _dataSource.signInWithApple(scopes: scopes);
    await _dataSource.addUser(user);
    return user;
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _dataSource.signInWithEmailAndPassword(email, password);
  }

  Future<void> createUserWithEmailAndPassword(String email, String password, String name) async {
    await _dataSource.createUserWithEmailAndPassword(email, password, name);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _dataSource.sendPasswordResetEmail(email);
  }

  Future<void> signOut() async {
    await _dataSource.signOut();
  }
}