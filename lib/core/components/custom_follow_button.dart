import 'package:flutter/material.dart';

class CustomFollowButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isFollowing;
  const CustomFollowButton({
    super.key,
    required this.onPressed,
    required this.isFollowing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          onPressed: onPressed,
          color: isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          padding: const EdgeInsets.all(25),
          child: Text(
            isFollowing ? 'Unfollow' : 'Follow',
          ),
        ),
      ),
    );
  }
}
