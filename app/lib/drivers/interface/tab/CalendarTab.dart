import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/drivers/logic/bloc/CalendarBloc.dart';
import 'package:mobile_app/drivers/model/CalendarModel.dart';
import 'package:mobile_app/logic/database.dart';

class CalendarTabDriver extends StatefulWidget {
  final List<CalendarModel> model;
  final StreamController<DateTime> dateStream;
  final date;
  final String user;

  CalendarTabDriver({
    @required this.model,
    @required this.dateStream,
    @required this.date,
    @required this.user,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarTabDriver>
    with AutomaticKeepAliveClientMixin {
  final _calendarBloc = CalendarBloc.of();

  @override
  void dispose() {
    super.dispose();
    _calendarBloc.close();
  }

  @override
  void initState() {
    //_calendarBloc.setDate(widget.date);
    super.initState();
    //print('lol');
  }

  void change(DateTime now) {
    print(now.toIso8601String());
    widget.dateStream.add(now);
  }

  bool isPresent(CalendarModel day) {
    //final user=UserBloc.of();
    //final str=await user.outFirebaseUser.first;
    if (day.free.contains(widget.user) || day.occupied.contains(widget.user))
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    //final user=UserBloc.of();
    //final cb = CalendarBloc.of();
    //if(widget.model.isNotEmpty && widget.model.first.day!=widget.date.toIso8601String()) widget.callback(widget.date);
    //final timeBloc=TimeBloc.of();
    //final date = (widget.model.isNotEmpty)?DateTime.tryParse(widget.model.first.day):DateTime.now();
    return StreamBuilder<List<CalendarModel>>(
        stream: Database().getShifts(widget.date),
        builder: (ctx, snap4) {
          if (!snap4.hasData) return Center(child: CircularProgressIndicator());
          return Container(
            child: new Column(
              children: <Widget>[
                new MonthPicker(
                  selectedDate: widget.date,
                  firstDate: new DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day - 1),
                  lastDate: new DateTime(2020),
                  //displayedMonth: new DateTime.now(),
                  //currentDate: new DateTime.now(),
                  onChanged: change,
                ),
                (snap4.data.isNotEmpty)
                    ? new ListView.builder(
                        shrinkWrap: true,
                        itemCount: snap4.data.length,
                        itemBuilder: (ctx, index) {
                          if (!isPresent(snap4.data.elementAt(index))) {
                            var temp = snap4.data.elementAt(index).free;
                            //temp.add(cb.user());
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Column(
                                  children: <Widget>[
                                    Text(snap4.data.elementAt(index).startTime,
                                        style: tt.body1),
                                    Text(snap4.data.elementAt(index).endTime,
                                        style: tt.body1),
                                  ],
                                ),
                                VerticalDivider(
                                  width: 2.0,
                                  color: Colors.grey,
                                ),
                                FlatButton(
                                    child: Text(
                                      'Conferma',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        backgroundColor: Colors.grey,
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Comfortaa',
                                      ),
                                    ),
                                    onPressed: () => {
                                          _calendarBloc.setShift(
                                              snap4.data
                                                  .elementAt(index)
                                                  .startTime,
                                              snap4.data
                                                  .elementAt(index)
                                                  .endTime,
                                              widget.date.toIso8601String(),
                                              temp)
                                        }),
                              ],
                            );
                          }
                          return Container();
                        })
                    : Text('Non ci sono turni disponibili per questo giorno.'),
              ],
            ),
          );
        });
    /*  margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date){
          this.setState(() => _currentdate = date),
        },
        thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
//      markedDates: _markedDate,
      weekFormat: false,
    //  markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate,
      daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
    ),
        weekendTextStyle: TextStyle(
        color: Colors.blue,
      ),
      ),*/
  }

  @override
  bool get wantKeepAlive => false;
}
