import 'package:flutter/material.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/styles/app_text_style.dart';

class VersionSheet extends StatelessWidget {
  const VersionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.deviceSize.height * 0.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text('Version 0.1', style: AppTextStyle.title),
            const SizedBox(height: 25),
            Text(
              'CopyRight © 2025 Tracker App. All rights reserved.',
              style: AppTextStyle.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            const Text(
              'Developed by: ',
              style: AppTextStyle.body,
            ),
            const SizedBox(height: 10),
            Text(
              'Dang Tung (Dazk-dev)',
              style: AppTextStyle.title2.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
