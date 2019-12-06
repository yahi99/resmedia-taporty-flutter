import 'dart:io';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/TurnScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/MenuPage.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/OrdersPage.dart';
import 'package:resmedia_taporty_flutter/restaurant/screen/TurnsScreen.dart';

import 'EditRestTurns.dart';

class TimetableScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'TimetableScreenRestaurant';
  final RestaurantBloc restBloc;
  final String restId;

  @override
  String get route => ROUTE;

  TimetableScreen({@required this.restBloc,@required this.restId});

  @override
  _HomeScreenRestaurantState createState() => _HomeScreenRestaurantState();
}

class _HomeScreenRestaurantState extends State<TimetableScreen> {

  List<String> days=['Lunedì','Martedì','Mercoledì','Giovedì','Venerdì','Sabato','Domenica'];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderBloc = OrdersBloc.of();
    return Scaffold(
        appBar: AppBar(
          title: Text("Orari"),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                //TODO modifica orario
                EasyRouter.push(context, EditRestTurns());
              },
              icon: Icon(Icons.mode_edit),
            )
          ],
        ),
        body: CacheStreamBuilder<RestaurantModel>(
          stream: widget.restBloc.outRestaurant,
          builder: (context, snap) {
            if(!snap.hasData) return Center(child: CircularProgressIndicator(),);
            final lunch=snap.data.lunch;
            final dinner=snap.data.dinner;
            String times='';
            //lunch.values.element at doesn't work need to do a remove and get the element
            for(int i=0;i<days.length;i++){
              if(lunch==null && dinner!=null){
                if(dinner.containsKey(days.elementAt(i))){
                  times=times +days.elementAt(i)+': '+dinner.values.elementAt(i)+'\n';
                }
                else times=times +days.elementAt(i)+': Chiuso\n';
              }
              else if(lunch!=null && dinner==null){
                if(lunch.containsKey(days.elementAt(i))){
                  times=times +days.elementAt(i)+': '+lunch.values.elementAt(i)+'\n';
                }
                else times=times +days.elementAt(i)+': Chiuso\n';
              }
              else if(lunch==null && dinner==null) times=times +days.elementAt(i)+': Chiuso\n';
              else if(lunch.containsKey(days.elementAt(i)) && dinner.containsKey(days.elementAt(i))){
                times=times +days.elementAt(i)+': '+lunch.values.elementAt(i)+','+dinner.values.elementAt(i)+'\n';
              }
              else if(!lunch.containsKey(days.elementAt(i)) && dinner.containsKey(days.elementAt(i))){
                times=times +days.elementAt(i)+': '+dinner.values.elementAt(i)+'\n';
              }
              else if(lunch.containsKey(days.elementAt(i)) && !dinner.containsKey(days.elementAt(i))){
                times=times +days.elementAt(i)+': '+lunch.values.elementAt(i)+'\n';
              }
              else if(!lunch.containsKey(days.elementAt(i)) && !dinner.containsKey(days.elementAt(i))){
                times=times +days.elementAt(i)+': Chiuso\n';
              }
            }
            return Padding(child:Text(times),padding: EdgeInsets.all(8.0));
          },
        ),
      );
  }
}
