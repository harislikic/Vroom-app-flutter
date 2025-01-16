import 'package:flutter/material.dart';

class CloseModalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final double iconSize;

  const CloseModalButton({
    super.key,
    required this.onPressed,
    this.color = Colors.blueGrey,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.close, color: color, size: iconSize),
      onPressed: onPressed,
    );
  }
}
