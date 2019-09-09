import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget trailing;

  const SearchBar({Key key, this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Expanded(
        child: TextField(
          scrollPadding: EdgeInsets.all(2.0),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: Colors.white,
            hintText: 'Search',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              gapPadding: 0.0,
              borderRadius: const BorderRadius.all(const Radius.circular(24.0)),
            ),
          ),
        ),
      ),
    ];
    if (trailing != null) children.add(trailing);

    return SizedBox(
      height: preferredSize.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: children,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(
        64,
        64,
      );
}
