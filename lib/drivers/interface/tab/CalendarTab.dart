import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:mobile_app/drivers/logic/bloc/CalendarBloc.dart';
import 'package:mobile_app/drivers/logic/bloc/TimeBloc.dart';
import 'package:mobile_app/drivers/model/CalendarModel.dart';
import 'package:mobile_app/drivers/model/ShiftModel.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';

class CalendarTabDriver extends StatefulWidget {
  final List<CalendarModel> model;
  final Function callback;
  final date;
  final String user;

  CalendarTabDriver({
    @required this.model,
    @required this.callback,
    @required this.date,
    @required this.user,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarTabDriver> with AutomaticKeepAliveClientMixin {

  final _calendarBloc=CalendarBloc.of();

  @override
  void dispose(){
    super.dispose();
    _calendarBloc.close();
  }

  @override
  void initState(){
    //_calendarBloc.setDate(widget.date);
    super.initState();
    //print('lol');
  }

  void change(DateTime now) {
    print(now.toIso8601String());
    widget.callback(now);
  }

  bool isPresent(CalendarModel day){
    //final user=UserBloc.of();
    //final str=await user.outFirebaseUser.first;
    if(day.users.contains(widget.user)) return true;
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
      return Container(
        child: new Column(
          children: <Widget>[
            new MonthPicker(
              selectedDate: widget.date,
              firstDate: new DateTime(DateTime
                  .now()
                  .year, DateTime
                  .now()
                  .month, DateTime
                  .now()
                  .day - 1),
              lastDate: new DateTime(2020),
              //displayedMonth: new DateTime.now(),
              //currentDate: new DateTime.now(),
              onChanged: change,
            ),
            /*new ListView.builder(
                shrinkWrap: true,
                itemCount: widget.model.length,
                itemBuilder: (ctx, index) {
                  if (!isPresent(widget.model.elementAt(index))) {
                    var temp = widget.model
                        .elementAt(index)
                        .users;
                    //temp.add(cb.user());
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            Text(widget.model
                                .elementAt(index)
                                .startTime, style: tt.body1),
                            Text(widget.model
                                .elementAt(index)
                                .endTime, style: tt.body1),
                          ],
                        ),
                        VerticalDivider(
                          width: 2.0,
                          color: Colors.grey,
                        ),
                        FlatButton(
                            child: Text('Conferma', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.grey,
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Comfortaa',
                            ),),
                            onPressed: () =>
                            {
                              _calendarBloc.setShift(widget.model
                                  .elementAt(index)
                                  .startTime, widget.model
                                  .elementAt(index)
                                  .endTime, widget.date.toIso8601String(),
                                  temp
                              )
                            }
                        ),
                      ],
                    );
                  }
                  return Container();
                }),*/
          ],
        ),
      );
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
