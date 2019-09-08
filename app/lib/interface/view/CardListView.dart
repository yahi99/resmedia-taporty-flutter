import 'package:flutter/material.dart';


class CardListView extends StatelessWidget {
  final List<Widget> children;

  const CardListView({Key key, @required this.children}) : assert(children != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.map<Widget>((child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: child,
        );
      }).toList(),
    );
  }
}
