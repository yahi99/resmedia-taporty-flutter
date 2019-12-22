import 'dart:async';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';

class TurnScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'TurnScreenPanel';

  final restId;

  TurnScreen({this.restId});

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
  //var timeStream = StreamController<List<CalendarModel>>();
  //var dropStreamHour = StreamController<String>();
  //var dropStreamTime = StreamController<String>();
  //final _dropKey = GlobalKey();
  //final _dropTimeKey = GlobalKey();
  final _dateKey = GlobalKey();
  final _quantityKey = GlobalKey<FormFieldState>();
  var hour;
  var time;

  StreamController _startTime,_endTime;
  List<DropdownMenuItem> drop = List<DropdownMenuItem>();
  List<DropdownMenuItem> dropTime = List<DropdownMenuItem>();
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
  TimeOfDay sTime,eTime;

  String  timeToString(TimeOfDay value){
    return ((value.hour<10)?'0'+value.hour.toString():value.hour.toString())+':'+((value.minute<10)?'0'+value.minute.toString():value.minute.toString());
  }

  bool isAfter(TimeOfDay start,TimeOfDay end){
    if(start.hour<end.hour) return true;
    if(start.hour==end.hour && start.minute<end.minute) return true;
    return false;
  }

  @override
  void dispose() {
    //_driverBloc.close();
    //_calendarBloc.close();
    super.dispose();
    _startTime.close();
    _endTime.close();
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
    _startTime=new StreamController<String>.broadcast();
    _endTime=new StreamController<String>.broadcast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Inserisci turni'),
      ),
        body:Column(
      children: <Widget>[
        StreamBuilder<DateTime>(
            stream: dateStream.stream,
            builder: (ctx, sp) {
              //if(!sp.hasData) return Center(child: CircularProgressIndicator(),);
              return Column(
                children: <Widget>[
                  Padding(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Giorno',
                      ),
                      controller: _dateController,
                      key: _dateKey,
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          initialDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(2020),
                        ).then((day) {
                          if (day != null) {
                            date = day;
                            print(day.toIso8601String());
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
        StreamBuilder<String>(
          stream: _startTime.stream,
          builder: (ctx, sp1) {
            return Padding(
              child:FlatButton(
                child: Text(sp1.hasData?sp1.data:'Inserisci Ora Inizio'),
                onPressed: (){
                  showTimePicker(context: context,initialTime: TimeOfDay.now()).then((value){
                    sTime=value;
                    _startTime.add(timeToString(value));
                  });
                },
              ),
              padding: EdgeInsets.only(bottom: SPACE),
            );
          },
        ),
        StreamBuilder<String>(
          stream: _endTime.stream,
          builder: (ctx, sp1) {
            return Padding(
              child:FlatButton(
                child: Text(sp1.hasData?sp1.data:'Inserisci Ora Fine'),
                onPressed: (){
                  showTimePicker(context: context,initialTime: TimeOfDay.now()).then((value){
                    eTime=value;
                    _endTime.add(timeToString(value));
                  });
                },
              ),
              padding: EdgeInsets.only(bottom: SPACE),
            );
          },
        ),
        /*Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Ora'),
              StreamBuilder<String>(
                stream: dropStreamHour.stream,
                builder: (ctx, sp1) {
                  return DropdownButton(
                    key: _dropKey,
                    value: (hour == null) ? hours.elementAt(0) : hour,
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
                    value: (time == null) ? startTime.elementAt(0) : time,
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
         */
        Padding(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Numero corrieri',
            ),
            validator: (value) {
              int temp=int.tryParse(value);
              if(temp==null) return 'Inserisci un numero';
              if (value.length == 0) return 'Campo non valido';
              return null;
            },
            key: _quantityKey,
            //controller: _quantityController,
            keyboardType: TextInputType.number,
          ),
          padding: EdgeInsets.all(SPACE),
        ),
        FlatButton(
          child: Text('Aggiungi Turni'),
          onPressed: () {
            if (date != null && _quantityKey.currentState.validate()) {
              if(eTime!=null && sTime!=null && isAfter(sTime, eTime)){
                final startHour=sTime.hour;
                final startMin=sTime.minute;
                final endHour=eTime.hour;
                final endMin=eTime.minute;
                int startIndex=int.tryParse(hours.elementAt(hours.indexOf(startHour.toString())));
                int endIndex=int.tryParse(hours.elementAt(hours.indexOf(endHour.toString())));
                if(startIndex!=null){
                  for(int i=startIndex;i<=endIndex;i++){
                    for(int j=0;j<endTime.length;j++){
                      if(startIndex==endIndex){
                        if(int.tryParse(endTime.elementAt(j))>=startMin && int.tryParse(endTime.elementAt(j))<=endMin){
                          Database()
                              .addShift(
                              hours.elementAt(i) + ':' + startTime.elementAt(j),
                              ((startTime.elementAt(j) == '45')
                                  ? hours.elementAt(i + 1)
                                  : hours.elementAt(i)) +
                                  ':' +
                                  endTime.elementAt(j),
                              date.toIso8601String(),
                              _quantityKey.currentState.value,widget.restId);
                        }
                      }
                      else if(i==startIndex && int.tryParse(endTime.elementAt(j))>=startMin){
                        Database()
                            .addShift(
                            hours.elementAt(i) + ':' + startTime.elementAt(j),
                            ((startTime.elementAt(j) == '45')
                                ? hours.elementAt(i + 1)
                                : hours.elementAt(i)) +
                                ':' +
                                endTime.elementAt(j),
                            date.toIso8601String(),
                            _quantityKey.currentState.value,widget.restId);
                      }
                      else if(i==endIndex && int.tryParse(endTime.elementAt(j))<=endMin){
                        Database()
                            .addShift(
                            hours.elementAt(i) + ':' + startTime.elementAt(j),
                            ((startTime.elementAt(j) == '45')
                                ? hours.elementAt(i + 1)
                                : hours.elementAt(i)) +
                                ':' +
                                endTime.elementAt(j),
                            date.toIso8601String(),
                            _quantityKey.currentState.value,widget.restId);
                      }
                      else if(i!=endIndex && i!=startIndex){
                        Database()
                            .addShift(
                            hours.elementAt(i) + ':' + startTime.elementAt(j),
                            ((startTime.elementAt(j) == '45')
                                ? hours.elementAt(i + 1)
                                : hours.elementAt(i)) +
                                ':' +
                                endTime.elementAt(j),
                            date.toIso8601String(),
                            _quantityKey.currentState.value,widget.restId);
                      }
                    }
                  }
                }
              }
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
