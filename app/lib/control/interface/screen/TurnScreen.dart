import 'dart:async';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/DriverBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/model/CalendarModel.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:toast/toast.dart';

class TurnScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'TurnScreenPanel';

  @override
  String get route => ROUTE;

  @override
  _TurnScreenPanelState createState() => _TurnScreenPanelState();
}

class _TurnScreenPanelState extends State<TurnScreen> {
  //final DriverBloc _driverBloc = DriverBloc.of();
  DateTime date;
  //final CalendarBloc _calendarBloc = CalendarBloc.of();
  var user;
  final TextEditingController _dateController = TextEditingController();
  var dateStream = StreamController<DateTime>();
  var timeStream = StreamController<List<CalendarModel>>();
  var dropStreamHour = StreamController<String>();
  var dropStreamTime = StreamController<String>();
  final _dropKey = GlobalKey();
  final _dropTimeKey = GlobalKey();
  final _dateKey = GlobalKey();
  final _quantityKey = GlobalKey<FormFieldState>();
  var hour;
  var time;
  List<DropdownMenuItem> drop =
  List<DropdownMenuItem>();
  List<DropdownMenuItem> dropTime =
  List<DropdownMenuItem>();
  final startTime = ['00', '15', '30', '45'];
  final hours = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23'
  ];
  final endTime = ['15', '30', '45', '00'];

  @override
  void dispose() {
    //_driverBloc.close();
    //_calendarBloc.close();
    super.dispose();
  }

  String toDate(DateTime date) {
    return (date.day.toString() +
        '/' +
        date.month.toString() +
        '/' +
        date.year.toString());
  }

  /*void setUser() async {
    final userB = UserBloc.of();
    user = (await userB.outFirebaseUser.first).uid;
  }*/

  @override
  void initState() {
    //stream=_calendarBloc.outCalendar;
    //setUser();
    for (int i = 0; i < hours.length; i++) {
      //values.add(snap.data.elementAt(i).startTime);
      drop.add(DropdownMenuItem(
        child: Text(hours.elementAt(i)),
        value: hours.elementAt(i),
      ));
    }
    for (int i = 0; i < startTime.length; i++) {
      //values.add(snap.data.elementAt(i).startTime);
      dropTime.add(DropdownMenuItem(
        child: Text(startTime.elementAt(i)),
        value: startTime.elementAt(i),
      ));
    }
    super.initState();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _quantityController = TextEditingController();
    _quantityController.value = TextEditingValue(text: '');
    return Scaffold(
      appBar: AppBar(
        title: Text("Inserimento Turni"),
        actions: <Widget>[],
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<DateTime>(
              stream: dateStream.stream,
              builder: (ctx, sp) {
                //if(!sp.hasData) return Center(child: CircularProgressIndicator(),);
                return Column(
                  children: <Widget>[
                    Padding(
                child:TextField(
                      decoration: InputDecoration(
                        labelText: 'Giorno',
                      ),
                      controller: _dateController,
                      key: _dateKey,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day - 1),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2020),
                        ).then((day) {
                          if (day != null) {
                            date = day;
                            _dateController.value =
                                TextEditingValue(text: toDate(date));
                            dateStream.add(day);
                          }
                        });
                      },
                    ),
                      padding: EdgeInsets.all(SPACE),
                    ),
                  ],
                );
              }),
          /*Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: SPACE, bottom: SPACE),
                child: Text('Orario:'),
              ),
            ],
          ),*/
        Padding(
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Ora'),
            StreamBuilder<String>(
              stream: dropStreamHour.stream,
              builder: (ctx, sp1) {
                return DropdownButton(
                  key: _dropKey,
                  value: (hour==null)
                      ? hours.elementAt(0):hour,
                  onChanged: (value) {
                    print(value);
                    hour = value;
                    //endTime = getEnd(snap.data, value);
                    dropStreamHour.add(value);
                  },
                  items: drop,
                );
              },
            ),
            Text('Minuti'),
            StreamBuilder<String>(
              stream: dropStreamTime.stream,
              builder: (ctx, sp2) {
                return DropdownButton(
                  key: _dropTimeKey,
                  value: (time==null)
                      ? startTime.elementAt(0):time,
                  onChanged: (value) {
                    print(value);
                    time = value;
                    //endTime = getEnd(snap.data, value);
                    dropStreamTime.add(value);
                  },
                  items: dropTime,
                );
              },
            ),

          ],
        ),
          padding: EdgeInsets.all(SPACE),
        ),
          Padding(
            child:TextFormField(
            decoration: InputDecoration(
              labelText: 'Numero corrieri',
            ),
            validator: (value) {
              if (value.length == 0)
                return 'Campo non valido';
              return null;
            },
            key: _quantityKey,
            controller: _quantityController,
            keyboardType: TextInputType.number,
          ),
            padding: EdgeInsets.all(SPACE),
          ),
          FlatButton(
            child: Text('Aggiungi Turno'),
            onPressed: (){
              if(time!=null && hour!=null && date!=null && _quantityKey.currentState.validate()){
                Database().addShift(hour+':'+time, ((time=='45')?hours.elementAt(hours.indexOf(hour)+1):hour)+':'+endTime.elementAt(startTime.indexOf(time)), date.toIso8601String(), _quantityKey.currentState.value).then((isPresent){
                  if(isPresent){
                    Toast.show('Orario già presente!', context,duration: 3);
                  }
                  else Toast.show('Orario inserito.', context,duration: 3);
                });
              }
            },
          ),

          /*StreamBuilder<List<CalendarModel>>(
            stream: (!sp.hasData)
                ? timeStream.stream
                : Database().getAvailableShifts(sp.data),
            builder: (ctx, snap) {
              debugPrint("Qui siamo nel builder.");
              List<DropdownMenuItem> drop = List<DropdownMenuItem>();
              List<String> values = List<String>();
              if (snap.hasData) {
                //time=snap.data.elementAt(0).startTime;
                if (snap.data.isNotEmpty) {
                  dropStream.add(snap.data.elementAt(0).startTime);
                  time = snap.data.elementAt(0).startTime;
                }
                for (int i = 0; i < snap.data.length; i++) {
                  values.add(snap.data.elementAt(i).startTime);
                  drop.add(DropdownMenuItem(
                    child: Text(snap.data.elementAt(i).startTime),
                    value: snap.data.elementAt(i).startTime,
                  ));
                }
              }
              return StreamBuilder<String>(
                stream: dropStream.stream,
                builder: (ctx, sp1) {
                  if (sp1.hasData) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        DropdownButton(
                          key: _dropKey,
                          value: (time == null)
                              ? values.elementAt(0)
                              : sp1.data,
                          onChanged: (value) {
                            print(value);
                            time = value;
                            endTime = getEnd(snap.data, value);
                            dropStream.add(value);
                          },
                          items: drop,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        Text(
                            'Non ci sono turni disponibili in questo giorno.'),
                      ],
                    );
                  }
                },
              );
            },
          ),*/
        ],
      ),
    );
  }
}
