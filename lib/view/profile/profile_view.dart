import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  final String uid;
  const ProfileView({super.key, required this.uid});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(widget.uid),
        ),
      ),
    );
  }
}
