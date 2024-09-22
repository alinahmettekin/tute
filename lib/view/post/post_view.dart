import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_comment_tile.dart';
import 'package:tute/core/components/custom_post_tile.dart';
import 'package:tute/core/helper/navigate_helper.dart';
import 'package:tute/core/models/post.dart';
import 'package:tute/core/service/database/database_provider.dart';

class PostView extends StatefulWidget {
  final Post post;
  const PostView({super.key, required this.post});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    final allComments = listeningProvider.getComments(widget.post.id);

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
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                'Comments',
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            allComments.isEmpty
                ? const Center(
                    child: Text('There is no comment yet...'),
                  )
                : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: allComments.length,
                    itemBuilder: (context, index) {
                      final comment = allComments[index];
                      return CustomCommentTile(
                        comment: comment,
                        onUserTap: () {},
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
