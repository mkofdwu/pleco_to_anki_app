import 'dart:async';

import 'package:flutter/material.dart';

class PressedBuilder extends StatefulWidget {
  final bool disabled;
  final Function() onPressed;
  final int animationDuration;
  final Widget Function(bool) builder;

  const PressedBuilder({
    super.key,
    this.disabled = false,
    required this.onPressed,
    this.animationDuration = 200,
    required this.builder,
  });

  @override
  PressedBuilderState createState() => PressedBuilderState();
}

class PressedBuilderState extends State<PressedBuilder> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.disabled) {
          setState(() => _pressed = true);
        }
      },
      onTapUp: (_) {
        Future.delayed(Duration(milliseconds: widget.animationDuration), () {
          if (!widget.disabled) widget.onPressed();
          setState(() => _pressed = false);
        });
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
      child: widget.builder(_pressed),
    );
  }
}
