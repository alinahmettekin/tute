import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tute/core/service/database/database_service.dart';

class FirebaseAuthService {
  static FirebaseAuthService? _instance;

  static FirebaseAuthService get instance {
    return _instance ??= FirebaseAuthService._internal();
  }

  FirebaseAuth? _auth;
  FirebaseAuthService._internal() {
    _auth = FirebaseAuth.instance;
  }
  User? getCurrentUser() => _auth!.currentUser;

  String getCurrentUserUid() => _auth!.currentUser!.uid;

  Future<UserCredential> loginWithEmailAndPassword(String email, password) async {
    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<UserCredential> registerWithEmailAndPassword(String email, password) async {
    try {
      final userCredential = await _auth!.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log('');
      throw Exception(e.code);
    }
  }

  Future<void> logout() async {
    await _auth!.signOut();
  }

  Future<void> deleteAccountInFirebase() async {
    User? user = getCurrentUser();

    if (user != null) {
      final _db = DatabaseService();

      await _db.deleteUserInfoInFirebase(user.uid);

      await user.delete();
    }
  }
}
