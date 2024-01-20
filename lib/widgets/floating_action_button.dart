import 'package:flutter/material.dart';
import 'package:pleco_to_anki/constants/palette.dart';
import 'package:pleco_to_anki/constants/animation.dart';
import 'package:pleco_to_anki/widgets/pressed_builder.dart';

class MyFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final bool isLoading;
  final Function() onPressed;

  const MyFloatingActionButton({
    Key? key,
    required this.icon,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressedBuilder(
      disabled: isLoading,
      onPressed: onPressed,
      builder: (pressed) => AnimatedScale(
        duration: shortAnimationDuration,
        scale: pressed ? 0.94 : 1,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isLoading ? Palette.black2 : Palette.primary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Palette.black.withOpacity(0.4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    icon,
                    color: Colors.black,
                  ),
          ),
        ),
      ),
    );
  }
}
