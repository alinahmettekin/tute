import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tute/core/models/comment.dart';
import 'package:tute/core/models/post.dart';
import 'package:tute/core/models/user_profile.dart';
import 'package:tute/core/service/auth/firebase_auth_service.dart';
import 'package:tute/core/service/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  final _db = DatabaseService();

  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

  Future<void> updateUserBio(String bio) => _db.updateUserBioInFirebase(bio);

  List<Post> _allposts = [];
  List<Post> _followingPosts = [];

  List<Post> get allPosts => _allposts;
  List<Post> get followingPosts => _followingPosts;

  Future<void> sendMessage(String message) async {
    await _db.postMessageInFireBase(message);
  }

  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();

    final blockedUserIds = await _db.getBlockedUidsFromFirebase();

    _allposts = allPosts.where((post) => !blockedUserIds.contains(post.uid)).toList();

    loadFollowingPosts();

    initializeLikeMap();

    notifyListeners();
  }

  Future<void> loadFollowingPosts() async {
    String currentUserId = FirebaseAuthService.instance.getCurrentUserUid();

    final followingUserIds = await _db.getFollowingUidsFromFirebase(currentUserId);

    _followingPosts = _allposts.where((post) => followingUserIds.contains(post.uid)).toList();

    notifyListeners();
  }

  List<Post> filterUserPosts(String uid) {
    return _allposts.where((post) => post.uid == uid).toList();
  }

  Future<void> deletePost(String postId) async {
    try {
      await _db.deletePostFromFirebase(postId);
      await loadAllPosts();
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, int> _likeCounts = {};
  List<String> _likedPosts = [];

  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

  void initializeLikeMap() {
    final currentUserId = FirebaseAuthService.instance.getCurrentUserUid();

    _likedPosts.clear();

    for (var post in _allposts) {
      _likeCounts[post.id] = post.likes;

      if (post.likedBy.contains(currentUserId)) {
        _likedPosts.add(post.id);
      }
    }
  }

  Future<void> toggleLike(String postId) async {
    final likedPostOriginal = _likedPosts;
    final likeCountsOriginal = _likeCounts;

    if (_likedPosts.contains(postId)) {
      _likedPosts.remove(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
    } else {
      _likedPosts.add(postId);
      _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
    }

    notifyListeners();

    try {
      await _db.toggleLikeInFirebase(postId);
    } catch (e) {
      _likedPosts = likedPostOriginal;
      _likeCounts = likeCountsOriginal;
      notifyListeners();
    }
  }

  final Map<String, List<Comment>> _comments = {};

  List<Comment> getComments(String postId) => _comments[postId] ?? [];

  Future<void> loadComments(String postId) async {
    final allComments = await _db.getCommentFromFirebase(postId);

    _comments[postId] = allComments;

    notifyListeners();
  }

  Future<void> addComment(String postId, String message) async {
    await _db.addCommentInFirebase(postId, message);
    await loadComments(postId);
  }

  Future<void> deleteComment(String commentId, String postId) async {
    await _db.deleteCommentInFirebase(commentId);
    await loadComments(postId);
  }

  List<UserProfile> _blockedUsers = [];

  List<UserProfile> get blockedUsers => _blockedUsers;

  Future<void> loadBlockedUsers() async {
    final blockedUserIds = await _db.getBlockedUidsFromFirebase();

    final blockedUsersData = await Future.wait(
      blockedUserIds.map(
        (id) => _db.getUserFromFirebase(id),
      ),
    );

    _blockedUsers = blockedUsersData.whereType<UserProfile>().toList();

    notifyListeners();
  }

  Future<void> blockUser(String userId) async {
    await _db.blockUserInFirebase(userId);

    await loadBlockedUsers();

    await loadAllPosts();

    notifyListeners();
  }

  Future<void> unblockUser(String userId) async {
    await _db.unblockUserInFirebase(userId);

    await loadAllPosts();

    await loadBlockedUsers();

    notifyListeners();
  }

  Future<void> reportUser(String postId, String userId) async {
    await _db.reportUserInFirebase(postId, userId);
  }

  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _followings = {};
  final Map<String, int> _followersCount = {};
  final Map<String, int> _followingsCount = {};

  int getfollowersCount(String uid) => _followersCount[uid] ?? 0;
  int getfollowingCount(String uid) => _followingsCount[uid] ?? 0;

  Future<void> loadUserFollowers(String userId) async {
    final listOfFollowersUids = await _db.getFollowersUidsFromFirebase(userId);
    _followers[userId] = listOfFollowersUids;
    _followersCount[userId] = listOfFollowersUids.length;

    notifyListeners();
  }

  Future<void> loadUserFollowings(String userId) async {
    final listOfFollowingsUids = await _db.getFollowingUidsFromFirebase(userId);
    _followings[userId] = listOfFollowingsUids;
    _followingsCount[userId] = listOfFollowingsUids.length;

    notifyListeners();
  }

  Future<void> followUser(String targetUserId) async {
    String currentUserId = FirebaseAuthService.instance.getCurrentUserUid();

    _followings.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if (!_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]?.add(currentUserId);

      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) + 1;

      _followings[currentUserId]!.add(targetUserId);

      _followingsCount[currentUserId] = (_followersCount[currentUserId] ?? 0) + 1;
    }

    notifyListeners();

    try {
      await _db.followUserInFirebase(targetUserId);

      await loadUserFollowers(currentUserId);

      await loadUserFollowings(currentUserId);
    } catch (e) {
      _followers[targetUserId]?.remove(currentUserId);

      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) - 1;

      _followings[currentUserId]?.remove(targetUserId);

      _followingsCount[currentUserId] = (_followersCount[currentUserId] ?? 0) - 1;

      notifyListeners();
    }
  }

  Future<void> unFollowUser(String targetUserId) async {
    String currentUserId = FirebaseAuthService.instance.getCurrentUserUid();

    _followings.putIfAbsent(
      currentUserId,
      () => [],
    );
    _followers.putIfAbsent(
      targetUserId,
      () => [],
    );

    if (_followers[targetUserId]!.contains(currentUserId)) {
      _followers[targetUserId]?.remove(currentUserId);

      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 1) - 1;

      _followings[currentUserId]?.remove(targetUserId);

      _followingsCount[currentUserId] = (_followingsCount[currentUserId] ?? 1) - 1;
    }

    notifyListeners();

    try {
      await _db.unFollowUserInFirebase(targetUserId);

      await loadUserFollowers(currentUserId);

      await loadUserFollowings(currentUserId);
    } catch (e) {
      print(e);

      _followers[targetUserId]?.add(currentUserId);

      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) + 1;

      _followings[currentUserId]?.add(targetUserId);

      _followingsCount[currentUserId] = (_followingsCount[currentUserId] ?? 0) + 1;

      notifyListeners();
    }
  }

  bool isFollowing(String targetUserId) {
    final currentUserId = FirebaseAuthService.instance.getCurrentUserUid();

    return _followers[targetUserId]?.contains(currentUserId) ?? false;
  }

  final Map<String, List<UserProfile>> _followersProfile = {};
  final Map<String, List<UserProfile>> _followingsProfile = {};

  List<UserProfile> getListOfFollowersProfiles(String uid) => _followersProfile[uid] ?? [];
  List<UserProfile> getListOfFollowingsProfiles(String uid) => _followingsProfile[uid] ?? [];

  Future<void> loadUserFollowersProfiles(String uid) async {
    try {
      final followersIds = await _db.getFollowersUidsFromFirebase(uid);

      List<UserProfile> followersProfiles = [];

      for (String followersId in followersIds) {
        UserProfile? followerProfile = await _db.getUserFromFirebase(followersId);

        if (followerProfile != null) {
          followersProfiles.add(followerProfile);
        }
      }

      _followersProfile[uid] = followersProfiles;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadUserFollowingsProfiles(String uid) async {
    try {
      final followingsIds = await _db.getFollowingUidsFromFirebase(uid);

      List<UserProfile> followingsProfiles = [];

      for (String followingId in followingsIds) {
        UserProfile? followingProfile = await _db.getUserFromFirebase(followingId);

        if (followingProfile != null) {
          followingsProfiles.add(followingProfile);
        }
      }

      _followingsProfile[uid] = followingsProfiles;

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  List<UserProfile> _searchResults = [];

  List<UserProfile> get searchResults => _searchResults;
  Future<void> searchUser(String searchTerm) async {
    try {
      final results = await _db.searchUsersInFirebase(searchTerm);
      _searchResults = results;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
