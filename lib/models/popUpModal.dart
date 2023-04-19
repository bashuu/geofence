// ignore: file_names
import 'package:flutter/material.dart';

class ConfirmationAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirmPressed;
  final VoidCallback onCancelPressed;

  const ConfirmationAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmButtonText = "Confirm",
    this.cancelButtonText = "Cancel",
    required this.onConfirmPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onCancelPressed,
          child: Text(cancelButtonText),
        ),
        TextButton(
          onPressed: onConfirmPressed,
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}
