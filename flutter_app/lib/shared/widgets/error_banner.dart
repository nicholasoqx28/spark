import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner(this.message, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Color(0xFFDC2626), fontSize: 13),
        ),
      );
}
