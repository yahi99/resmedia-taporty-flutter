import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Subutton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color color;

  Subutton({
    this.color,
    @required this.onTap,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 48,
      child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
          onPressed: onTap,
          color: color ?? theme.buttonColor,
          child: DefaultTextStyle(
            style: theme.textTheme.button,
            child: child,
          )),
    );
  }
}
