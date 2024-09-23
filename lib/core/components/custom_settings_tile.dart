import 'package:flutter/material.dart';

class CustomSettingsTile extends StatelessWidget {
  final Widget action;
  final String title;

  const CustomSettingsTile({super.key, required this.action, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      padding: const EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          action,
        ],
      ),
    );
  }
}
