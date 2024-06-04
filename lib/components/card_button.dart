import 'package:flutter/material.dart';

class CardButton extends StatefulWidget {
  CardButton({
    required this.colour,
    required this.cardChild,
    this.onTapDown,
    this.onTapUp,
  });
  final Color colour;
  final Widget cardChild;
  final Future<void> Function()? onTapDown; // Function to call on tap down
  final Future<void> Function()? onTapUp; // Function to call on tap up
  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        isPressed = true;
        if (widget.onTapDown != null) {
          widget.onTapDown!(); // Call onTapDown function if provided
        }
      }),
      onTapUp: (_) => setState(() {
        isPressed = false;
        if (widget.onTapUp != null) {
          widget.onTapUp!(); // Call onTapUp function if provided
        }
      }),
      child: Container(
        child: widget.cardChild,
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: isPressed ? widget.colour.withOpacity(0.8) : widget.colour,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
