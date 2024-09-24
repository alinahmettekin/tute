import 'package:firebase_auth/firebase_auth.dart';
import 'package:tute/core/models/comment.dart';
import 'package:tute/core/models/post.dart';
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

  Future<void> updateUserBioInFirebase(String bio) async {
    String uid = FirebaseAuthService.instance.getCurrentUserUid();
    try {
      await _db.collection('Users').doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  Future<void> postMessageInFireBase(String message) async {
    try {
      String uid = FirebaseAuthService.instance.getCurrentUserUid();

      UserProfile? user = await getUserFromFirebase(uid);

      Post newPost = Post(
          id: '',
          uid: uid,
          name: user!.name,
          username: user.username,
          message: message,
          timestamp: Timestamp.now(),
          likes: 0,
          likedBy: []);

      Map<String, dynamic> newPostMap = newPost.toMap();

      await _db.collection('Posts').add(newPostMap);
    } catch (e) {}
  }

  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db.collection('Posts').orderBy('timestamp', descending: true).get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection('Posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      String uid = FirebaseAuthService.instance.getCurrentUserUid();

      DocumentReference postDoc = _db.collection('Posts').doc(postId);

      await _db.runTransaction(
        (transaction) async {
          DocumentSnapshot postSnapshot = await transaction.get(postDoc);

          List<String> likedBy = List<String>.from(postSnapshot['likedBy'] ?? []);

          int likes = postSnapshot['likes'];

          if (!likedBy.contains(uid)) {
            likedBy.add(uid);
            likes++;
          } else {
            likedBy.remove(uid);
            likes--;
          }

          transaction.update(
            postDoc,
            {
              'likes': likes,
              'likedBy': likedBy,
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> addCommentInFirebase(String postId, String message) async {
    try {
      String currentUserId = FirebaseAuthService.instance.getCurrentUserUid();
      UserProfile? user = await getUserFromFirebase(currentUserId);

      Comment comment = Comment(
        id: '',
        postId: postId,
        uid: user!.uid,
        name: user.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
      );

      Map<String, dynamic> commentMap = comment.toMap();
      await _db.collection('Comments').add(commentMap);
    } catch (e) {
      print(e.toString() + 'burası mı');
    }
  }

  Future<void> deleteCommentInFirebase(commentId) async {
    try {
      await _db.collection('Comments').doc(commentId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Comment>> getCommentFromFirebase(String postId) async {
    try {
      QuerySnapshot snapshot = await _db.collection('Comments').where('postId', isEqualTo: postId).get();
      return snapshot.docs.map((e) => Comment.fromDocument(e)).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> reportUserInFirebase(String postId, String userId) async {
    final currentUser = _auth.getCurrentUser();

    final report = {
      'reportedBy': currentUser!.uid,
      'messageId': postId,
      'messageOwnerId': userId,
      'timestamp': FieldValue.serverTimestamp()
    };

    await _db.collection('Reports').add(report);
  }

  Future<void> blockUserInFirebase(String userId) async {
    final currentUserId = _auth.getCurrentUserUid();

    await _db.collection('Users').doc(currentUserId).collection('BlockedUsers').doc(userId).set({});
  }

  Future<void> unblockUserInFirebase(String blockedUserId) async {
    final currentUserId = _auth.getCurrentUserUid();

    await _db.collection('Users').doc(currentUserId).collection('BlockedUsers').doc(blockedUserId).delete();
  }

  Future<List<String>> getBlockedUidsFromFirebase() async {
    final currentUserId = _auth.getCurrentUserUid();

    final snapshot = await _db.collection('Users').doc(currentUserId).collection('BlockedUsers').get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> deleteUserInfoInFirebase(String userId) async {
    WriteBatch batch = _db.batch();

    DocumentReference userDoc = _db.collection('Users').doc(userId);
    batch.delete(userDoc);

    QuerySnapshot posts = await _db.collection('Posts').where('uid', isEqualTo: userId).get();
    for (var post in posts.docs) {
      batch.delete(post.reference);
    }

    QuerySnapshot comments = await _db.collection('Comments').where('uid', isEqualTo: userId).get();
    for (var comment in comments.docs) {
      batch.delete(comment.reference);
    }

    QuerySnapshot allPosts = await _db.collection('Posts').get();
    for (QueryDocumentSnapshot post in allPosts.docs) {
      Map<String, dynamic> postData = post.data() as Map<String, dynamic>;
      var likedBy = postData['likedBy'] as List<dynamic>? ?? [];

      if (likedBy.contains(userId)) {
        batch.update(post.reference, {
          'likedBy': FieldValue.arrayRemove([userId]),
          'likes': FieldValue.increment(-1)
        });
      }
    }

    await batch.commit();
  }

  Future<void> followUserInFirebase(String userId) async {
    String currentUserId = _auth.getCurrentUserUid();

    await _db.collection('Users').doc(currentUserId).collection('Followings').doc(userId).set({});

    await _db.collection('Users').doc(userId).collection('Followers').doc(currentUserId).set({});
  }

  Future<void> unFollowUserInFirebase(String userId) async {
    String currentUserId = _auth.getCurrentUserUid();

    await _db.collection('Users').doc(currentUserId).collection('Followings').doc(userId).delete();
    await _db.collection('Users').doc(userId).collection('Followers').doc(currentUserId).delete();
  }

  Future<List<String>> getFollowersUidsFromFirebase(String userId) async {
    final snapshot = await _db.collection('Users').doc(userId).collection('Followers').get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> getFollowingUidsFromFirebase(String userId) async {
    final snapshot = await _db.collection('Users').doc(userId).collection('Followings').get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<UserProfile>> searchUsersInFirebase(String searchTerm) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('Users')
          .where('username', isGreaterThanOrEqualTo: searchTerm)
          .where('username', isLessThanOrEqualTo: '$searchTerm\uf8ff')
          .get();

      return snapshot.docs.map((user) => UserProfile.fromDocument(user)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
