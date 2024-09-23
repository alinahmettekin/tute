import 'package:flutter/material.dart';

class CustomProfileStats extends StatelessWidget {
  final int postCounts;
  final int followersCount;
  final int followingsCount;
  final void Function()? onTap;

  const CustomProfileStats({
    super.key,
    required this.postCounts,
    required this.followersCount,
    required this.followingsCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var textStyleForCount = TextStyle(
      fontSize: 20,
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    var textStyleForText = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  postCounts.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  'Posts',
                  style: textStyleForText,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followersCount.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  'Followers',
                  style: textStyleForText,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  followingsCount.toString(),
                  style: textStyleForCount,
                ),
                Text(
                  'Followings',
                  style: textStyleForText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
