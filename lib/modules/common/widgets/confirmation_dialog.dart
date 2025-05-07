import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
  BuildContext context,
  String title,
  Widget content,
  // List<Widget> actions,
) async {
  return await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(title),
              content: content,
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Tidak'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Ya'),
                ),
              ],
            ),
      ) ??
      false;
}
