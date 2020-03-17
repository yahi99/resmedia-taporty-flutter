import 'package:flutter/cupertino.dart';
import 'package:resmedia_taporty_core/core.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function onTap;

  @override
  final Size preferredSize;

  HomeAppBar({@required this.onTap}) : preferredSize = Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Container(
        color: ColorTheme.RED,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
      ),
    );
  }
}
