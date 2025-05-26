import 'package:flutter/material.dart';
import 'package:pos_app/utils/constants/colors.dart';

class AppStyles {
  static InputDecoration textFieldDecoration({
    required String hintText,
    String? prefixText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
      isDense: true,
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }
}
