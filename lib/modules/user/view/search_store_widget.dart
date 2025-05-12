import 'package:flutter/material.dart';
import 'package:pos_app/modules/store/data/models/store_model.dart';

class StoreSearchDropdown extends StatefulWidget {
  final List<StoreModel> items;
  final Function(StoreModel) onChanged;
  final StoreModel? selectedItem;

  const StoreSearchDropdown({super.key, required this.items, required this.onChanged, this.selectedItem});

  @override
  State<StoreSearchDropdown> createState() => _StoreSearchDropdownState();
}

class _StoreSearchDropdownState extends State<StoreSearchDropdown> {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  List<StoreModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.selectedItem?.storeName ?? '';
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _filteredItems = widget.items;
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 5),
              child: Material(
                elevation: 4,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children:
                      _filteredItems.map((store) {
                        return ListTile(
                          title: Text(store.storeName),
                          onTap: () {
                            _controller.text = store.storeName;
                            widget.onChanged(store);
                            _focusNode.unfocus();
                          },
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(labelText: "Pilih Toko", suffixIcon: Icon(Icons.arrow_drop_down)),
        onChanged: (value) {
          setState(() {
            _filteredItems = widget.items.where((e) => e.storeName.toLowerCase().contains(value.toLowerCase())).toList();
            _overlayEntry?.markNeedsBuild();
          });
        },
      ),
    );
  }
}
