import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/components/custom_input_box.dart';
import 'package:tute/core/models/post.dart';
import 'package:tute/core/service/auth/firebase_auth_service.dart';
import 'package:tute/core/service/database/database_provider.dart';

class CustomPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;
  const CustomPostTile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<CustomPostTile> createState() => _CustomPostTileState();
}

class _CustomPostTileState extends State<CustomPostTile> {
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  final _commentController = TextEditingController();

  void _showOptions() {
    String currentUserId = FirebaseAuthService.instance.getCurrentUserUid();
    final bool postOwner = widget.post.uid == currentUserId;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            if (postOwner) ...[
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () async {
                  Navigator.pop(context);
                  await databaseProvider.deletePost(widget.post.id);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ] else ...[
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Report'),
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block user'),
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e.toString());
    }
  }

  void _openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => CustomInputBox(
        controller: _commentController,
        hintText: 'Type Comment',
        onPressed: () async {
          databaseProvider.addComment(widget.post.id, _commentController.text);
        },
        onPressedText: 'Send',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int commentCount = listeningProvider.getComments(widget.post.id).length;
    final likeCount = listeningProvider.getLikeCount(widget.post.id);
    bool likedByCurrentUser = listeningProvider.isPostLikedByCurrentUser(widget.post.id);
    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.post.name,
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '@${widget.post.username}',
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => _showOptions(),
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.post.message),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleLikePost,
                        child: likedByCurrentUser
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        likeCount != 0 ? likeCount.toString() : '',
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openNewCommentBox(),
                      child: Icon(
                        Icons.comment,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(commentCount != 0 ? commentCount.toString() : '')
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
