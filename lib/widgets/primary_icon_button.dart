import 'package:flutter/material.dart';
import 'package:pleco_to_anki/constants/palette.dart';
import 'package:pleco_to_anki/constants/animation.dart';
import 'package:pleco_to_anki/widgets/pressed_builder.dart';

class PrimaryIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const PrimaryIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressedBuilder(
      onPressed: onPressed,
      builder: (pressed) => AnimatedScale(
        duration: shortAnimationDuration,
        scale: pressed ? 0.9 : 1,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Palette.primary,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Icon(icon, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
