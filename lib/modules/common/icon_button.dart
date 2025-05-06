import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 24,
      height: size ?? 24,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(child: Icon(icon, size: 14, color: color)),
        ),
      ),
    );
  }
}
