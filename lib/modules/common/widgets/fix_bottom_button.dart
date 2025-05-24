import 'package:flutter/material.dart';

class FixedBottomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;

  const FixedBottomButton({super.key, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        child: Text(text ?? ''),
      ),
    );
  }
}
