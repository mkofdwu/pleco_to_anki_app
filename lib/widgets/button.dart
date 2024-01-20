import 'package:flutter/material.dart';
import 'package:pleco_to_anki/constants/palette.dart';
import 'package:pleco_to_anki/constants/animation.dart';
import 'package:pleco_to_anki/widgets/default_feedback.dart';

class MyButton extends StatelessWidget {
  final String text;
  final double height;
  final bool isPrimary;
  final bool loading;
  final Function() onPressed;

  const MyButton({
    Key? key,
    required this.text,
    this.height = 50,
    this.isPrimary = true,
    this.loading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultFeedback(
      disabled: loading,
      onPressed: onPressed,
      child: AnimatedContainer(
        duration: mediumAnimationDuration,
        height: height,
        decoration: BoxDecoration(
          color: loading
              ? Palette.black2
              : Palette.primary.withOpacity(isPrimary ? 1 : 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: isPrimary ? Colors.black : Palette.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
