import 'package:tute/core/models/user_profile.dart';
import 'package:tute/core/service/auth/firebase_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _auth = FirebaseAuthService.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> saveUserInfoInFirebase({required String name, required String email}) async {
    String uid = _auth.getCurrentUser()!.uid;

    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      username: username,
      email: email,
      bio: '',
    );

    final userMap = user.toMap();

    await _db.collection('Users').doc(uid).set(userMap);
  }

  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection('Users').doc(uid).get();

      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
