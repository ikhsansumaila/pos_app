import 'package:flutter/material.dart';
import 'package:pos_app/utils/constants/colors.dart';

class AppStyles {
  static InputDecoration textFieldDecoration({required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
      isDense: true,
      suffixIcon: suffixIcon,
    );
  }
}
