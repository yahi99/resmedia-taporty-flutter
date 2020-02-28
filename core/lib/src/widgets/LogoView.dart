import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/src/config/Assets.dart';

class LogoView extends StatelessWidget {
  final Widget top;
  final List<Widget> children;
  final double logoHeight;

  const LogoView({Key key, this.top, @required this.children, this.logoHeight = 128})
      : assert(children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(Assets.loginBackground),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (top != null)
              SafeArea(
                right: false,
                left: false,
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 48.0),
                  child: SizedBox(
                    height: 64,
                    child: top,
                  ),
                ),
              ),
            if (top == null)
              Container(
                height: 100,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Center(
                child: Image.asset(Assets.logo, height: logoHeight, fit: BoxFit.contain),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            ...children,
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
