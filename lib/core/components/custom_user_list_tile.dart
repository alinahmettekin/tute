import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tute/core/models/user_profile.dart';
import 'package:tute/view/profile/profile_view.dart';

class CustomUserListTile extends StatelessWidget {
  final UserProfile user;

  const CustomUserListTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProfileView(uid: user.uid),
          ),
        ),
        title: Text(user.name),
        titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        subtitle: Text('@${user.username}'),
        subtitleTextStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
