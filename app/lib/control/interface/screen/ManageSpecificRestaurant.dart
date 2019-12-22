import 'dart:async';

import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/page/ManageRestPage.dart';
import 'package:resmedia_taporty_flutter/control/interface/page/MenuCtrlPage.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/IncomeScreen.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ManageSpecificRestaurant extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ManageSpecificUser";

  final RestaurantModel rest;
  final RestaurantBloc restBloc;

  String get route => ROUTE;

  ManageSpecificRestaurant({@required this.rest,@required this.restBloc});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ManageSpecificRestaurant> {

  StreamController dateStream;


  @override
  void initState(){
    super.initState();
    dateStream=StreamController<DateTime>.broadcast();
  }

  @override
  void dispose() {
    super.dispose();
    dateStream.close();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
        child:Scaffold(
      appBar: AppBar(
        title: Text("Gestisci ristorante"),
        actions: <Widget>[

        ],
        bottom: TabBar(
          tabs: [
            Tab(
              text: 'Listino',
            ),
            Tab(
              text: 'Gestione',
            ),
            Tab(
              text: 'Saldo',
            )
          ],
        ),
      ),
      body: StreamBuilder<List<DrinkModel>>(
            stream: widget.restBloc.outDrinksCtrl,
            builder: (context, drinks) {
              return StreamBuilder<List<FoodModel>>(
                stream: widget.restBloc.outFoodsCtrl,
                builder: (context, foods) {
                  if (!foods.hasData || !drinks.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      MenuCtrlPage(
                        foods: foods.data,
                        drinks: drinks.data,
                      ),
                      StreamBuilder(
                        stream: widget.restBloc.outRestaurant,
                        builder: (context,snap){
                          return ManageRestPage(restId: widget.rest.id,rest:snap.hasData?snap.data:widget.rest);
                        },
                      ),
                      StreamBuilder<DateTime>(
                        stream: dateStream.stream,
                        builder: (ctx,snap){
                          return IncomeScreen(restId:widget.rest.id,date: snap.hasData?snap.data:DateTime.now(),dateStream: dateStream,);
                        },
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
    );
  }
}
