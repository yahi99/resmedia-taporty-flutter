import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';

class Order extends StatelessWidget {
  final List<Widget> children;
  final String date;

  const Order({
    Key key,
    @required this.date,
    @required this.children,
  }) : super(key: key);

  String toDate(String date){
    final DateTime dateTime=DateTime.parse(date);
    return(dateTime.day.toString()+'/'+dateTime.month.toString()+'/'+dateTime.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    final tt=Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Data: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(toDate(date)),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: SPACE, left: SPACE, right: SPACE),
          ),
          Row(
            children: children,
          ),
        ],
      ),
    );
  }
}
