import 'dart:async';
import 'dart:io';

import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/RestaurantDetailedRequest.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/DriverRequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/RequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/RestaurantRequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/model/DriverRequestModel.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/control/model/RestaurantRequestModel.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';

import 'ArchivedRestaurantRequests.dart';
import 'DriverDetailedRequest.dart';

class RestaurantRequestsScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'RestaurantRequestScreenPanel';

  @override
  String get route => ROUTE;

  @override
  _RestaurantRequestsScreenState createState() =>
      _RestaurantRequestsScreenState();
}

class _RestaurantRequestsScreenState extends State<RestaurantRequestsScreen> {
  RestaurantRequestsBloc reqBloc;

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
    final tt = Theme.of(context).textTheme;
    reqBloc = RestaurantRequestsBloc.of();
    return Scaffold(
      appBar: AppBar(
        title: Text("Richieste Ristoratori"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.archive),
            onPressed: (){
              EasyRouter.push(context, ArchivedRestaurantRequests());
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: reqBloc.outRequests,
        builder: (context, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          if (snap.data.length == 0) {
            return Padding(
              child: Text(
                'Non ci sono richieste da approvare.',
                style: tt.subtitle,
              ),
              padding: EdgeInsets.all(SPACE),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              return ItemBuilder(model: snap.data.elementAt(index));
            },
            itemCount: snap.data.length,
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.black,
              );
            },
          );
        },
      ),
    );
  }
}

class ItemBuilder extends StatelessWidget {
  final RestaurantRequestModel model;
  final StreamController<String> imgStream = new StreamController<String>();

  ItemBuilder({@required this.model});

  Future<Null> downloadFile(String httpPath) async {
    final RegExp regExp = RegExp('([^?/]*\.(jpg))');
    final String fileName = regExp.stringMatch(httpPath);
    final Directory tempDir = Directory.systemTemp;
    final File file = File('${tempDir.path}/$fileName');
    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageFileDownloadTask downloadTask = ref.writeToFile(file);
    final int byteNumber = (await downloadTask.future).totalByteCount;
    print(byteNumber);
    //put the file into the stream
    imgStream.add(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    //downloadFile(model.img);
    return InkWell(
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Ragione Sociale: ',
                        style: tt.subtitle,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        child: Text(model.ragioneSociale),
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(top: SPACE, left: SPACE, right: SPACE),
              ),
              Container(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Tipologia: ',
                        style: tt.subtitle,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        child: Text(model.tipoEsercizio),
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(top: SPACE, left: SPACE, right: SPACE),
              ),
              Container(
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Indirizzo: ',
                        style: tt.subtitle,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        child: Text(model.address),
                      ),
                    ),
                  ],
                ),
                padding: EdgeInsets.only(
                    top: SPACE, left: SPACE, right: SPACE, bottom: SPACE),
              ),
            ],
          ),
      onTap: () {
        //_showDialog(context);
        EasyRouter.push(
            context,
            RestaurantDetailedRequest(
              isArchived: false,
              model: model,
            ));
      },
    );
  }
}