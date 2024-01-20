import 'package:flutter/material.dart';
import 'package:pleco_to_anki/constants/animation.dart';

import 'pressed_builder.dart';

class DefaultFeedback extends StatelessWidget {
  final double pressedOpacity;
  final bool disabled;
  final Function() onPressed;
  final Widget child;

  const DefaultFeedback({
    Key? key,
    this.pressedOpacity = 0.8,
    this.disabled = false,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PressedBuilder(
      disabled: disabled,
      onPressed: onPressed,
      animationDuration: 100,
      builder: (pressed) => AnimatedOpacity(
        duration: shortAnimationDuration,
        opacity: pressed ? pressedOpacity : 1,
        child: AnimatedScale(
          duration: shortAnimationDuration,
          scale: pressed ? 0.98 : 1,
          child: child,
        ),
      ),
    );
  }
}
