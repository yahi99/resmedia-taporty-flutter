import 'dart:async';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/DriverRequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/RequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/model/DriverRequestModel.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/control/model/RestaurantRequestModel.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';

class RestaurantDetailedRequest extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'RestaurantDetailedRequest';

  final RestaurantRequestModel model;
  final bool isArchived;

  RestaurantDetailedRequest({this.model,this.isArchived});

  @override
  String get route => ROUTE;

  @override
  _RestaurantDetailedState createState() => _RestaurantDetailedState();
}

class _RestaurantDetailedState extends State<RestaurantDetailedRequest> {
  final StreamController<String> imgStream = new StreamController<String>();

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
    downloadFile(widget.model.img);
    return Scaffold(
      appBar: new AppBar(title: Text('Dettaglio Richiesta')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            widget.model.img,
            width: MediaQuery.of(context).size.width,
          ),
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
                    child: Text(widget.model.ragioneSociale),
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
                    child: Text(widget.model.tipoEsercizio),
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
                    child: Text(widget.model.address),
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
                    'Copertura in Km: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(widget.model.km.toString()),
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
                    'Partita Iva: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(widget.model.partitaIva),
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
                    'Prodotti: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(widget.model.prodType),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.only(top: SPACE, left: SPACE, right: SPACE),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment:CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  if(!widget.isArchived) Database().archiveVendor(widget.model);
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
                  Database().addRestaurant(widget.model);
                  EasyRouter.pop(context);
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
    );
  }
}
