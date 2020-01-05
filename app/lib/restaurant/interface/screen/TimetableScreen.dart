import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';

import 'EditRestTurns.dart';

class TimetableScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'TimetableScreenRestaurant';
  final RestaurantBloc restBloc;
  final String restId;

  @override
  String get route => ROUTE;

  TimetableScreen({@required this.restBloc, this.restId});

  @override
  _HomeScreenRestaurantState createState() => _HomeScreenRestaurantState();
}

class _HomeScreenRestaurantState extends State<TimetableScreen> {
  List<String> days = ['Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato', 'Domenica'];

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
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Padding(child: Text(snap.data.getTimetableString()), padding: EdgeInsets.all(8.0));
        },
      ),
    );
  }
}
