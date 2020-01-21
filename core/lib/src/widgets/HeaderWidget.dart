import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/src/config/ColorTheme.dart';

class HeaderWidget extends StatelessWidget {
  final String text;
  const HeaderWidget(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: ColorTheme.LIGHT_GREY,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          text,
          style: theme.textTheme.body1,
        ),
      ),
    );
  }
}
