import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    ),
  );
}

// Usage
// Example: showCustomSnackBar(context, 'Invalid credentials', Colors.red);
