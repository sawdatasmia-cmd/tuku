import 'package:flutter/material.dart';

class TukuButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;

  const TukuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton(
        onPressed: onPressed,
        child: Text(text),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}