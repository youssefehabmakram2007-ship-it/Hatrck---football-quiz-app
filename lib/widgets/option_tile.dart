import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/glass.dart';

class OptionTile extends StatelessWidget {
  final String text;
  final bool isAnswered, isCorrect, isPicked;
  final VoidCallback onTap;
  const OptionTile({
    super.key,
    required this.text,
    required this.isAnswered,
    required this.isCorrect,
    required this.isPicked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? tint;
    if (isAnswered) {
      if (isCorrect) {
        tint = AppColors.green;
      } else if (isPicked) {
        tint = AppColors.red;
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: isAnswered ? null : onTap,
        child: Glass(
          tint: tint,
          radius: 18,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Text(text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}
