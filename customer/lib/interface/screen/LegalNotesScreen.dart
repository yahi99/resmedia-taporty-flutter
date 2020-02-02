import 'package:flutter/material.dart';

class LegalNotesScreen extends StatefulWidget {
  @override
  _LegalNotesState createState() => _LegalNotesState();
}

class _LegalNotesState extends State<LegalNotesScreen> {
  var cookie = false;
  var conditions = false;
  var privacy = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Note legali",
          style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0 * 2),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text('Termini e condizioni'),
                    ),
                    IconButton(
                        icon: Icon((!conditions) ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                        onPressed: () {
                          setState(() {
                            //_bodyHeight = 100.0;
                            conditions = !conditions;
                          });
                        }),
                  ],
                ),
                AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: Text('Termini e condizioni'),
                  height: (!conditions) ? 0.0 : 20.0,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text('Privacy Policy'),
                    ),
                    IconButton(
                        icon: Icon((!privacy) ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                        onPressed: () {
                          setState(() {
                            //_bodyHeight = 100.0;
                            privacy = !privacy;
                          });
                        }),
                  ],
                ),
                AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: Text('Privacy Policy'),
                  height: (!privacy) ? 0.0 : 20.0,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text('Cookies Policy'),
                    ),
                    IconButton(
                        icon: Icon((!cookie) ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                        onPressed: () {
                          setState(() {
                            //_bodyHeight = 100.0;
                            cookie = !cookie;
                          });
                        }),
                  ],
                ),
                AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: Text('Cookies Policy'),
                  height: (!cookie) ? 0.0 : 20.0,
                ),
              ],
            ),
          ].map((child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0 * 2),
              child: child,
            );
          }).toList(),
        ),
      ),
    );
  }
}
