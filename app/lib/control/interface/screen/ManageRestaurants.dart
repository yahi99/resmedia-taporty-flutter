import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/HomeScreenPanel.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/UsersBloc.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/HomeScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:toast/toast.dart';

import 'ManageSpecificRestaurant.dart';
import 'ManageSpecificUser.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ManageRestaurants extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ManageRestaurants";

  String get route => ROUTE;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ManageRestaurants> {

  _showPositionDialog(BuildContext context,String restId) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        final cls = theme.colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sicuro di volere eliminare il ristorante?",
                    style: theme.textTheme.body2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          EasyRouter.pop(context);
                        },
                        textColor: Colors.white,
                        color: Colors.red,
                        child: Text(
                          "Nega",
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Database().deleteRestaurant(restId);
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Consenti",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestisci ristoranti"),
          actions: <Widget>[],
        ),
        body: StreamBuilder<List<RestaurantModel>>(
          stream: RestaurantsBloc.of().outRestaurants,
          builder: (ctx, snap) {
            if (!snap.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (ctx, index) {
                return Divider(
                  height: 4.0,
                );
              },
              itemBuilder: (ctx,index){
                final rest=snap.data.elementAt(index);
                return Slidable(
                    child:InkWell(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Image.network(rest.img),
                          Text(rest.id),
                        ],
                      )
                    ],
                  ),
                  onTap: (){
                    final restBloc=RestaurantBloc.init(idRestaurant: rest.id);
                    EasyRouter.push(context,ManageSpecificRestaurant(rest:rest,restBloc: restBloc,));
                  },
                ),
                  secondaryActions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: (){
                        _showPositionDialog(context,rest.id);
                      },
                    )
                  ],
                );
              },

            );
          },
        ));
  }
}
