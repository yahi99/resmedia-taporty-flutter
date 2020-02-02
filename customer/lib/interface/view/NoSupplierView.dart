import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoSupplierView extends StatelessWidget {
  final String message;
  const NoSupplierView({Key key, this.message = "Non sono disponibili fornitori corrispondenti ai criteri di ricerca."}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          ),
        ),
        Icon(FontAwesomeIcons.exclamationTriangle, size: 100, color: Colors.grey),
      ],
    );
  }
}
