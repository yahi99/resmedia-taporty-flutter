import 'dart:async';
import 'dart:io';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';

class ProductDetailedRequest extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'ProductDetailedRequest';

  final ProductRequestModel model;
  final isArchive;

  ProductDetailedRequest({this.model,this.isArchive});

  @override
  String get route => ROUTE;

  @override
  _ProductDetailedState createState() => _ProductDetailedState();
}

class _ProductDetailedState extends State<ProductDetailedRequest> {
  //final StreamController<String> imgStream = new StreamController<String>();

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
    //imgStream.add(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    //downloadFile(widget.model.img);
    return Scaffold(
      appBar: new AppBar(title: Text('Dettaglio Richiesta')),
      body: ListView(
        shrinkWrap: true,
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
                    'Nome Prodotto: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(widget.model.title),
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
                    'Ristorante: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(widget.model.restaurantId),
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
                    'Prezzo: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(widget.model.price),
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
                    'Categoria: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(widget.model.cat),
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
                    child: Text(widget.model.category),
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
                    'Limite ordine: ',
                    style: tt.subtitle,
                  ),
                ),
                Flexible(
                  child: Container(
                    child: Text(widget.model.quantity),
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
                  EasyRouter.pop(context);
                  if(!widget.isArchive) Database().archiveProduct(widget.model);
                  else{
                    Database().deleteProductRequest(widget.model);
                  }
                },
                textColor: Colors.white,
                color: Colors.red,
                child: Text(
                  "Nega",
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Database().addProduct(widget.model);
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
