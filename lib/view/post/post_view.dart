import 'package:flutter/material.dart';
import 'package:tute/core/components/custom_post_tile.dart';
import 'package:tute/core/helper/navigate_helper.dart';
import 'package:tute/core/models/post.dart';

class PostView extends StatefulWidget {
  final Post post;
  const PostView({super.key, required this.post});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            CustomPostTile(
              post: widget.post,
              onUserTap: () => goUserPage(context, widget.post.uid),
              onPostTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
