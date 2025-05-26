import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final Color color;
  final double iconSize;
  final double buttonSize;

  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
    this.iconSize = 24,
    this.buttonSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(buttonSize / 2),
          onTap: onPressed,
          child: Center(child: Icon(icon, size: iconSize, color: color)),
        ),
      ),
    );
  }
}
