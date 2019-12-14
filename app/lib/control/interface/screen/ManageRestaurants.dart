import 'package:cloud_functions/cloud_functions.dart';
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
  _showPositionDialog(BuildContext context, String restId) {
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
                          EasyRouter.pop(context);
                          CloudFunctions.instance.getHttpsCallable(functionName: 'deleteRestaurant').call({
                            'restaurantId':restId
                          }).then((isDone){
                            Toast.show('Ristorante cancellato!', context);
                          });
                          //Database().deleteRestaurant(restId);
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
            if (snap.data.length > 0)
              return ListView.builder(
                itemCount: snap.data.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  final rest = snap.data.elementAt(index);
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: InkWell(
                      child: Padding(
                        child: RestaurantView(
                          model: rest,
                        ),
                        padding: EdgeInsets.all(8.0),
                      ),
                      onTap: () {
                        final restBloc =
                            RestaurantBloc.init(idRestaurant: rest.id);
                        EasyRouter.push(
                            context,
                            ManageSpecificRestaurant(
                              rest: rest,
                              restBloc: restBloc,
                            ));
                      },
                    ),
                    secondaryActions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _showPositionDialog(context, rest.id);
                        },
                      )
                    ],
                  );
                },
              );
            return Padding(
              child: Text('Non ci sono ristoranti'),
              padding: EdgeInsets.all(8.0),
            );
          },
        ));
  }
}

class RestaurantView extends StatelessWidget {
  final RestaurantModel model;

  RestaurantView({this.model});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          (model.img.startsWith('assets'))
              ? Image.asset(
                  model.img,
                  fit: BoxFit.fitHeight,
                )
              : Image.network(
                  model.img,
                  fit: BoxFit.fitHeight,
                ),
          Container(
            color: Colors.black,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: TextStyle(fontSize: 20),
                      child: Text("${model.id}"),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
