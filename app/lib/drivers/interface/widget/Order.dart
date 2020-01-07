import 'package:flutter/material.dart';

class Order extends StatelessWidget {
  final List<Widget> children;
  final String date;
  final String endTime;
  final bool isNear;

  const Order({
    Key key,
    this.isNear,
    this.endTime,
    this.date,
    @required this.children,
  }) : super(key: key);

  String toDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return (dateTime.day.toString() + '/' + dateTime.month.toString() + '/' + dateTime.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: (isNear != null && isNear) ? Colors.red : Colors.grey[300]),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: children,
          ),
          if (date != null)
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
                      child: Text(toDate(date) + ' alle ' + endTime),
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
            ),
        ],
      ),
    );
  }
}
