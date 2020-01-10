import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';

class ShiftView extends StatelessWidget {
  final ShiftModel shift;

  ShiftView({Key key, @required this.shift}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  child: Column(
                    children: <Widget>[
                      Text(DateTimeHelper.getTimeString(shift.startTime), style: tt.body1),
                      Text(DateTimeHelper.getTimeString(shift.endTime), style: tt.body1),
                    ],
                  ),
                  padding: EdgeInsets.only(left: 16.0),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Container(
                    height: 30.0,
                    width: 2.0,
                    color: Colors.grey,
                  ),
                ),
                Text(DateTimeHelper.getDayString(shift.startTime)),
              ],
            ),
          ),
          if (shift.startTime.difference(DateTime.now()).inHours > 48)
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text(
                'Annulla',
              ),
              textColor: Colors.black,
              color: ColorTheme.LIGHT_GREY,
              onPressed: () => {},
            ),
        ],
      ),
    );
  }
}