import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static FirebaseAuthService? _instance;

  static FirebaseAuthService get instance {
    return _instance ??= FirebaseAuthService._internal();
  }

  FirebaseAuth? _auth;
  FirebaseAuthService._internal() {
    _auth = FirebaseAuth.instance;
  }
  void getBilmemNe() {}
  User? getCurrentUser() => _auth!.currentUser;

  String getCurrentUserUid() => _auth!.currentUser!.uid;

  Future<UserCredential> loginWithEmailAndPassword(String email, password) async {
    try {
      final userCredential = await _auth!.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.toString() == '[firebase_auth/invalid-email] The email address is badly formatted.]') {
        print('evet');
      }
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
}
