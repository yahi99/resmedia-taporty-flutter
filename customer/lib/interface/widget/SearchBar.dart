import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget leading;
  final Widget trailing;
  final StreamController searchBarStream;

  const SearchBar({Key key, this.leading, this.trailing, @required this.searchBarStream}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();

  @override
  Size get preferredSize => const Size(
        64,
        64,
      );
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _textController;
  StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    if (oldWidget.searchBarStream != widget.searchBarStream) {
      _subscription.cancel();
      _subscription = widget.searchBarStream.stream.listen((text) {
        if (text != _textController.value) _textController.value = text;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _subscription = widget.searchBarStream.stream.listen((text) {
      if (text != _textController.text) _textController.text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      if (widget.leading != null) widget.leading,
      Expanded(
        child: TextField(
          onChanged: (value) {
            widget.searchBarStream.add(value);
          },
          controller: _textController,
          scrollPadding: EdgeInsets.all(2.0),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Cerca',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              gapPadding: 0.0,
              borderRadius: const BorderRadius.all(const Radius.circular(24.0)),
            ),
          ),
        ),
      ),
      if (widget.trailing != null) widget.trailing,
    ];

    return SizedBox(
      height: widget.preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
