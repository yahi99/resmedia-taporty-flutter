import 'package:flutter/material.dart';


class BottomButtonBar extends StatelessWidget {
  final Widget child;
  final Color color;

  const BottomButtonBar({Key key, @required this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color??Theme.of(context).colorScheme.secondary,
      child: SafeArea(
        top: false, left: false, right: false,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: child,
        ),
      ),
    );
  }
}
