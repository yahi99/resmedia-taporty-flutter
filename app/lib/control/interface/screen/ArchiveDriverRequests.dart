import 'dart:async';
import 'dart:io';

import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/DriverRequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/RequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/model/DriverRequestModel.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';

import 'DriverDetailedRequest.dart';

class ArchiveDriverRequests extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'ArchivedDriverRequestScreenPanel';

  @override
  String get route => ROUTE;

  @override
  _DriverRequestsScreenState createState() => _DriverRequestsScreenState();
}

class _DriverRequestsScreenState extends State<ArchiveDriverRequests> {
  DriverRequestsBloc reqBloc;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    DriverRequestsBloc.instance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tt=Theme.of(context).textTheme;
    reqBloc=DriverRequestsBloc.of();
    return Scaffold(
      appBar: AppBar(
        title: Text("Richieste Fattorini Archiviate"),
        actions: <Widget>[],
      ),
      body: StreamBuilder(
        stream:reqBloc.outArchivedRequests ,
        builder: (context,snap){
          if(!snap.hasData) return Center(child:CircularProgressIndicator());
          if(snap.data.length==0){
            return Padding(
              child:Text('Non ci sono richieste archiviate.',style: tt.subtitle,),
              padding: EdgeInsets.all(SPACE),
            );
          }
          return ListView.separated(
            itemBuilder: (context,index){
              return ItemBuilder(model:snap.data.elementAt(index));
            },
            itemCount: snap.data.length,
            separatorBuilder: (context,index){
              return Divider(color: Colors.black,);
            },
          );
        },
      ),
    );
  }
}

class ItemBuilder extends StatelessWidget{

  final DriverRequestModel model;

  ItemBuilder({
    @required this.model
  });

  @override
  Widget build(BuildContext context) {
    final tt=Theme.of(context).textTheme;
    return InkWell(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(child:Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(child: Text('Nome: ',style:tt.subtitle ,),),
              Flexible(child: Container(child: Text(model.nominative),),),

            ],
          ),
            padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE),
          ),
          Container(child:Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(child: Text('Esperienza: ',style:tt.subtitle ,),),
              Flexible(child: Container(child: Text(model.experience),),),

            ],
          ),
            padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE),
          ),
          Container(child:Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(child: Text('Mezzo di trasporto: ',style:tt.subtitle ,),),
              Flexible(child: Container(child: Text(model.mezzo),),),

            ],
          ),
            padding: EdgeInsets.only(top:SPACE,left: SPACE,right: SPACE,bottom: SPACE),
          ),
        ],
      ),
      onTap:() {
        //_showDialog(context);
        EasyRouter.push(context, DriverDetailedRequest(model: model,isArchived: true,));
      },
    );
  }

}
