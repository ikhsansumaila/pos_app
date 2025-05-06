import 'package:flutter/material.dart';
import 'package:pos_app/utils/constants/colors.dart';

class AppBasePage extends StatefulWidget {
  const AppBasePage({
    super.key,
    required this.appBar,
    required this.mainWidget,
    // this.mainWidgetPadding = const EdgeInsets.all(0),
    this.fixedBottomWidget,
  });

  final PreferredSizeWidget appBar;
  final Widget mainWidget;
  // final EdgeInsetsGeometry mainWidgetPadding;
  final Widget? fixedBottomWidget;

  @override
  State<AppBasePage> createState() => _AppBasePageState();
}

class _AppBasePageState extends State<AppBasePage> {
  final GlobalKey _bottomKey = GlobalKey();
  double _bottomHeight = 0;

  @override
  void initState() {
    super.initState();
    // Tunggu frame selesai, baru ukur tinggi widget
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateBottomHeight());
  }

  void _updateBottomHeight() {
    final context = _bottomKey.currentContext;
    if (context != null) {
      final newHeight = context.size?.height ?? 0;
      if (_bottomHeight != newHeight) {
        setState(() {
          _bottomHeight = newHeight;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final EdgeInsetsGeometry effectivePadding = widget.mainWidgetPadding.add(
    //   EdgeInsets.only(bottom: _bottomHeight),
    // );
    return Scaffold(
      appBar: widget.appBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: _bottomHeight + 20),
                child: widget.mainWidget,
              ),
            ),
            if (widget.fixedBottomWidget != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: KeyedSubtree(
                  key: _bottomKey,
                  child: widget.fixedBottomWidget!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
