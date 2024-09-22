import 'package:flutter/material.dart';
import 'package:tute/core/models/comment.dart';

class CustomCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const CustomCommentTile({
    super.key,
    required this.comment,
    required this.onUserTap,
  });

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
                  onTap: () {},
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
