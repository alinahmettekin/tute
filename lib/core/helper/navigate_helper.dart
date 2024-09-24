import 'package:flutter/material.dart';
import 'package:tute/core/models/post.dart';
import 'package:tute/view/blocked/blocked_view.dart';
import 'package:tute/view/delete_account/delete_account_view.dart';
import 'package:tute/view/home/home_view.dart';
import 'package:tute/view/post/post_view.dart';
import 'package:tute/view/profile/profile_view.dart';

void goUserPage(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfileView(uid: uid),
    ),
  );
}

void goPostPage(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostView(
        post: post,
      ),
    ),
  );
}

void goBlockedPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const BlockedView(),
    ),
  );
}

void goDeleteAccountPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const DeleteAccountView(),
    ),
  );
}

void goHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const HomeView(),
    ),
    (route) => route.isFirst,
  );
}
