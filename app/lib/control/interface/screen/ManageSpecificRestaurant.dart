import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_flutter/control/interface/page/ManageRestPage.dart';
import 'package:resmedia_taporty_flutter/control/interface/page/MenuCtrlPage.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/HomeScreenPanel.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/UsersBloc.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/HomeScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/IncomeScreen.dart';
import 'package:toast/toast.dart';

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
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
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
