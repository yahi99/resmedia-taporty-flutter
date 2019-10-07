import 'dart:async';
import 'dart:io';

import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/RequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';

class ProductRequestsScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'TurnScreenPanel';

  @override
  String get route => ROUTE;

  @override
  _ProductRequestsScreenState createState() => _ProductRequestsScreenState();
}

class _ProductRequestsScreenState extends State<ProductRequestsScreen> {
  RequestsBloc reqBloc;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    RequestsBloc.instance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tt=Theme.of(context).textTheme;
    reqBloc=RequestsBloc.of();
    return Scaffold(
      appBar: AppBar(
        title: Text("Richieste Prodotti"),
        actions: <Widget>[],
      ),
      body: StreamBuilder(
        stream:reqBloc.outRequests ,
        builder: (context,snap){
          if(!snap.hasData) return Center(child:CircularProgressIndicator());
          if(snap.data.length==0){
            return Padding(
                child:Text('Non ci sono richieste da approvare.',style: tt.subtitle,),
              padding: EdgeInsets.all(SPACE),
            );
          }
          return ListView.builder(
            itemBuilder: (context,index){
              return ItemBuilder(model:snap.data.elementAt(index));
            },
            itemCount: snap.data.length,
          );
        },
      ),
    );
  }
}

class ItemBuilder extends StatelessWidget{

  final ProductRequestModel model;
  final StreamController<String> imgStream = new StreamController<String>();

  ItemBuilder({
    @required this.model
  });

  void _showDialog(BuildContext context){
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
                    "Consenti aggiunta prodotto?",
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
                          Database().addProduct(model);
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
            ],
          ),
        );
      },
    );
  }

  Future<Null> downloadFile(String httpPath)async{
    final RegExp regExp=RegExp('([^?/]*\.(jpg))');
    final String fileName=regExp.stringMatch(httpPath);
    final Directory tempDir= Directory.systemTemp;
    final File file=File('${tempDir.path}/$fileName');
    final StorageReference ref=FirebaseStorage.instance.ref().child(fileName);
    final StorageFileDownloadTask downloadTask=ref.writeToFile(file);
    final int byteNumber=(await downloadTask.future).totalByteCount;
    print(byteNumber);
    //put the file into the stream
    imgStream.add(file.path);
  }

  @override
  Widget build(BuildContext context) {
    downloadFile(model.img);
    final tt=Theme.of(context).textTheme;
    return InkWell(
        child:Padding(
        child:Row(
      children: <Widget>[
        StreamBuilder<String>(
          stream: imgStream.stream,
          builder: (context,snap){
            if(!snap.hasData) return Center(child:CircularProgressIndicator());
            return Image.asset(snap.data,height: 140.0,width: 140.0,);
          },
        ),
        Padding(
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nome: ',style:tt.subtitle ,),
            Text(model.id),
            Text('Ristorante: ',style:tt.subtitle ,),
            Text(model.restaurantId),
            Text('Prezzo: ',style:tt.subtitle ,),
            Text(model.price+' euro'),
          ],
        ),
          padding: EdgeInsets.only(left: 4.0),
        ),
      ],
        ),
      padding: EdgeInsets.only(bottom:4.0,left:SPACE),
        ),
      onTap:() {
          _showDialog(context);
      },
    );
  }

}