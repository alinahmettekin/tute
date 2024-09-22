import 'package:flutter/material.dart';

class CustomInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final void Function() onPressed;
  final String onPressedText;

  const CustomInputBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onPressed,
    required this.onPressedText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: TextField(
        controller: controller,
        maxLength: 140,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Theme.of(context).colorScheme.primary,
          filled: true,
          counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            controller.clear();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();

            onPressed();
          },
          child: Text(onPressedText),
        )
      ],
    );
  }
}
