import 'package:flutter/material.dart';

class CustomBioBox extends StatelessWidget {
  final String text;

  const CustomBioBox({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Text(
        text.isNotEmpty ? text : 'Empty Bio...',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
