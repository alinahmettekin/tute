import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tute/core/models/comment.dart';
import 'package:tute/core/service/auth/firebase_auth_service.dart';
import 'package:tute/core/service/database/database_provider.dart';

class CustomCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const CustomCommentTile({
    super.key,
    required this.comment,
    required this.onUserTap,
  });

  void _showOptions(BuildContext context) {
    String currentUserId = FirebaseAuthService.instance.getCurrentUserUid();
    final bool isOwnComment = comment.uid == currentUserId;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            if (isOwnComment) ...[
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () async {
                  Navigator.pop(context);
                  await Provider.of<DatabaseProvider>(context, listen: false).deleteComment(comment.id, comment.postId);
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
            onTap: onUserTap,
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
                  comment.name,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '@${comment.username}',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showOptions(context),
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
          Text(comment.message),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
