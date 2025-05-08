import 'package:flutter/material.dart';
import 'package:pos_app/utils/responsive_helper.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.searchController,
    required this.hintText,
  });

  final TextEditingController searchController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper responsive = ResponsiveHelper(MediaQuery.of(context).size);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.9),
      ),
      child: TextField(
        controller: searchController,
        style: TextStyle(
          color: Colors.black,
          fontSize: responsive.fontSize(20),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.blueGrey,
            fontSize: responsive.fontSize(20),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          // suffixIcon: BarcodeScanner(),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        ),
      ),
    );
  }
}
