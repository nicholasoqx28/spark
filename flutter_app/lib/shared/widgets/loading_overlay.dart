import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
      );
}
