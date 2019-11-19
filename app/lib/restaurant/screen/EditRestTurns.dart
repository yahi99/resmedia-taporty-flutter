import 'dart:async';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/sliver/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/TurnView.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';

class EditRestTurns extends StatefulWidget implements WidgetRoute {

  static const ROUTE = 'EditTurnsRestaurant';

  @override
  String get route => ROUTE;

  @override
  _TurnWorkTabDriverState createState() => _TurnWorkTabDriverState();
}

class _TurnWorkTabDriverState extends State<EditRestTurns>{

  StreamController day;
  StreamController isLunch;
  StreamController startTime;
  StreamController endTime;

  String dayWeek,isL;
  TimeOfDay sTime,eTime;

  List<DropdownMenuItem> dropDays = List<DropdownMenuItem>();
  List<DropdownMenuItem> dropTime = List<DropdownMenuItem>();
  //List<DropdownMenuItem> dropDrinks = List<DropdownMenuItem>();

  List<String> days=['Lunedì','Martedì','Mercoledì','Giovedì','Venerdì','Sabato','Domenica'];
  List<String> time=['Pranzo','Cena'];

  String  timeToString(TimeOfDay value){
    return ((value.hour<10)?'0'+value.hour.toString():value.hour.toString())+':'+((value.minute<10)?'0'+value.minute.toString():value.minute.toString());
  }

  bool isAfter(TimeOfDay start,TimeOfDay end){
    if(start.hour<end.hour) return true;
    if(start.minute<end.minute) return true;
    return false;
  }

  @override
  void initState() {
    super.initState();
    day=new StreamController<String>.broadcast();
    isLunch=new StreamController<String>.broadcast();
    startTime=new StreamController<String>.broadcast();
    endTime=new StreamController<String>.broadcast();
    for(int i=0;i<days.length;i++){
      dropDays.add(DropdownMenuItem(
        child: Text(days[i]),
        value: days[i],
      ));
    }
    for(int i=0;i<time.length;i++){
      dropTime.add(DropdownMenuItem(
        child: Text(time[i]),
        value: time[i],
      ));
    }
    dayWeek=days.elementAt(0);
    isL=time.elementAt(0);
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  void dispose(){
    super.dispose();
    day.close();
    isLunch.close();
    startTime.close();
    endTime.close();
  }

  @override
  Widget build(BuildContext context) {
    //final turnBloc = TurnBloc.of();
    /*return StreamBuilder<Map<MonthCategory,List<TurnModel>>>(
        stream: turnBloc.outCategorizedTurns ,
        builder: (ctx,snap){
          if(!snap.hasData) return Center(child: CircularProgressIndicator(),);*/
    return Scaffold(
      body: Column(
        children: <Widget>[
          StreamBuilder<String>(
            stream: day.stream,
            builder: (ctx, sp1) {
              return Padding(
                    child:DropdownButton(
                      //key: _dropKey,
                      value: (!sp1.hasData)
                          ? days.elementAt(0)
                          : sp1.data,
                      onChanged: (value) {
                        print(value);
                        dayWeek = value;
                        day.add(value);
                      },
                      items: dropDays,
                    ),
                padding: EdgeInsets.only(bottom: SPACE * 2),
              );
            },
          ),
          StreamBuilder<String>(
            stream: isLunch.stream,
            builder: (ctx, sp1) {
              return Padding(
                child:DropdownButton(
                  //key: _dropKey,
                  value: (!sp1.hasData)
                      ? time.elementAt(0)
                      : sp1.data,
                  onChanged: (value) {
                    print(value);
                    isL = value;
                    isLunch.add(value);
                  },
                  items: dropTime,
                ),
                padding: EdgeInsets.only(bottom: SPACE * 2),
              );
            },
          ),
          StreamBuilder<String>(
            stream: startTime.stream,
            builder: (ctx, sp1) {
              return Padding(
                child:FlatButton(
                  child: Text(sp1.hasData?sp1.data:'Inserisci Ora Inizio'),
                  onPressed: (){
                    showTimePicker(context: context,initialTime: TimeOfDay.now()).then((value){
                      sTime=value;
                      startTime.add(timeToString(value));
                    });
                  },
                ),
                padding: EdgeInsets.only(bottom: SPACE * 2),
              );
            },
          ),
          StreamBuilder<String>(
            stream: endTime.stream,
            builder: (ctx, sp1) {
              return Padding(
                child:FlatButton(
                  child: Text(sp1.hasData?sp1.data:'Inserisci Ora Fine'),
                  onPressed: (){
                    showTimePicker(context: context,initialTime: TimeOfDay.now()).then((value){
                      eTime=value;
                      endTime.add(timeToString(value));
                    });
                  },
                ),
                padding: EdgeInsets.only(bottom: SPACE * 2),
              );
            },
          ),
          RaisedButton(
            child: Text('Modifica Orari'),
            onPressed: ()async{
              //(await FirebaseAuth.instance.currentUser()).metadata.lastSignInTimestamp;
              if(eTime!=null && sTime!=null && dayWeek!=null && isL!=null){
                if(isAfter(sTime, eTime)){
                  Database().updateTime(dayWeek,isL,timeToString(sTime),timeToString(eTime),(await UserBloc.of().outUser.first).model.restaurantId);
                }
              }
            },
          )
        ],
      ),
    );
    /*},
    );*/
  }
}
