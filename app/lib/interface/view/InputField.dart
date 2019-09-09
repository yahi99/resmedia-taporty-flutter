import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Widget title, body;

  const InputField({Key key, @required this.title, @required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.subtitle,
            child: title,
          ),
        ),
        body,
      ],
    );
  }
}
