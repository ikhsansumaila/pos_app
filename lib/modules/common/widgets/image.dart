import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.errorBuilder,
    this.fit,
  });

  final String? url;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url ?? "https://loremflickr.com/320/240",
      width: width ?? 50,
      height: height ?? 50,
      fit: fit ?? BoxFit.cover,
      errorBuilder: errorBuilder ?? (c, e, s) => Icon(Icons.broken_image),
    );
  }
}
