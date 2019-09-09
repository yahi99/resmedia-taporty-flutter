import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/data/img.dart';

class LogoView extends StatelessWidget {
  final Widget top;
  final List<Widget> children;

  const LogoView({Key key, this.top, @required this.children})
      : assert(children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(Img.back_log),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 56),
        children: <Widget>[
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Cfg.LOGO_SPACE),
            child: Image.asset(Img.logotest),
          ),
          SizedBox(
            height: 32,
          ),
        ]..addAll(children),
      ),
    );
  }
}
