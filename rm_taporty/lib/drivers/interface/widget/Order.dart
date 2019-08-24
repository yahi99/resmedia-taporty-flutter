import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  final List<Widget> children;

  const Order({Key key,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: children,
      ),
    );
  }
}




