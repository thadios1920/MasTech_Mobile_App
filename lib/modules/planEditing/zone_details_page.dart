import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onModifyPressed;

  CustomDialog({
    required this.title,
    required this.message,
    this.onDeletePressed,
    this.onModifyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (onDeletePressed != null)
          TextButton(
            onPressed: onDeletePressed,
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (onModifyPressed != null)
          TextButton(
            onPressed: onModifyPressed,
            child: const Text('Modifier'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
