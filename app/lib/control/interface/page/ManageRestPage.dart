import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/sliver/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/TurnView.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/interface/screen/SeeReviewsScreen.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:toast/toast.dart';

class ManageRestPage extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'TurnsRestaurant';

  @override
  String get route => ROUTE;

  final String restId;
  final RestaurantModel rest;

  ManageRestPage({@required this.restId, @required this.rest});

  @override
  _TurnWorkTabDriverState createState() => _TurnWorkTabDriverState();
}

class _TurnWorkTabDriverState extends State<ManageRestPage> {
  StreamController img;

  String path, _path;

  final _descrKey = new GlobalKey<FormFieldState>();
  final _delKey = new GlobalKey<FormFieldState>();
  final _kmKey = new GlobalKey<FormFieldState>();

  Future<String> uploadFile(String filePath) async {
    final Uint8List bytes = File(filePath).readAsBytesSync();
    final Directory tempDir = Directory.systemTemp;
    final String fileName = filePath.split('/').last;
    final File file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(file);
    //final Uri downloadUrl = (await task.onComplete).uploadSessionUri;

    //_path = downloadUrl.toString();
    _path = (await ref.getDownloadURL());
    print(_path);
    return _path;
  }

  @override
  void initState() {
    super.initState();
    img = new StreamController<String>.broadcast();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  void dispose() {
    super.dispose();
    img.close();
  }

  @override
  Widget build(BuildContext context) {
    //final turnBloc = TurnBloc.of();
    /*return StreamBuilder<Map<MonthCategory,List<TurnModel>>>(
        stream: turnBloc.outCategorizedTurns ,
        builder: (ctx,snap){
          if(!snap.hasData) return Center(child: CircularProgressIndicator(),);*/
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text(
                    'Disabilitato: ' + ((widget.rest.isDisabled==null || !widget.rest.isDisabled) ? 'No' : 'Si')),
                width: MediaQuery.of(context).size.width * 2 / 3,
                padding: EdgeInsets.all(8.0),
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Cambia'),
                  onPressed: () {
                    Database().changeStatusRest(widget.rest);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                child: Padding(
                  child: TextFormField(
                    key: _kmKey,
                    validator: (value) {
                      bool isWrong = value.contains(',');
                      if (isWrong) return 'Punto per i decimali';
                      if (double.tryParse(value) == null) {
                        return 'Inserisci un numero';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Raggio consegne",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  padding: EdgeInsets.all(8.0),
                ),
                width: MediaQuery.of(context).size.width * 2 / 3,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Cambia'),
                  onPressed: () async {
                    if (_kmKey.currentState.validate()) {
                      Database()
                          .updateKm(
                              double.parse(_kmKey.currentState.value),
                              (await UserBloc.of().outUser.first)
                                  .model
                                  .restaurantId)
                          .then((value) {
                        Toast.show('Cambiato!', context, duration: 3);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                child: Padding(
                  child: TextFormField(
                    key: _delKey,
                    validator: (value) {
                      //print(value);
                      bool isWrong = value.contains(',');
                      if (isWrong) return 'Punto per i decimali';
                      if (double.tryParse(value) == null) {
                        return 'Inserisci un numero';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Costo consegna",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  padding: EdgeInsets.all(8.0),
                ),
                width: MediaQuery.of(context).size.width * 2 / 3,
              ),
              Expanded(
                  child: RaisedButton(
                child: Text('Cambia'),
                onPressed: () async {
                  //print(double.tryParse('2.6').toString());
                  if (_delKey.currentState.validate()) {
                    Database()
                        .updateDeliveryFee(
                            double.tryParse(_delKey.currentState.value),
                            (await UserBloc.of().outUser.first)
                                .model
                                .restaurantId)
                        .then((value) {
                      Toast.show('Cambiato!', context, duration: 3);
                    });
                  }
                },
              )),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                child: Padding(
                  child: TextFormField(
                    key: _descrKey,
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Inserisci descrizione';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Inserisci una descrizione...",
                    ),
                    maxLines: 10,
                    minLines: 5,
                    keyboardType: TextInputType.text,
                  ),
                  padding: EdgeInsets.all(8.0),
                ),
                width: MediaQuery.of(context).size.width * 2 / 3,
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Cambia'),
                  onPressed: () async {
                    if (_descrKey.currentState.validate()) {
                      Database()
                          .updateDescription(
                              _descrKey.currentState.value,
                              (await UserBloc.of().outUser.first)
                                  .model
                                  .restaurantId)
                          .then((value) {
                        Toast.show('Cambiato!', context, duration: 3);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              StreamBuilder(
                stream: img.stream,
                builder: (ctx, snap) {
                  if (snap.hasData)
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(SPACE),
                        child: Image.file(File(path)),
                        width: MediaQuery.of(context).size.width * 2 / 3,
                      ),
                      onTap: () {
                        ImagePicker.pickImage(source: ImageSource.gallery)
                            .then((file) {
                          if (file != null) {
                            path = file.path;
                            img.add(path.split('/').last);
                          } else {
                            Toast.show('Devi scegliere un\'immagine!', context,
                                duration: 3);
                          }
                        }).catchError((error) {
                          if (error is PlatformException) {
                            if (error.code == 'photo_access_denied')
                              Toast.show(
                                  'Devi garantire accesso alle immagini!',
                                  context,
                                  duration: 3);
                          }
                        });
                      },
                    );
                  return Container(
                    child: FlatButton(
                      child: Text('Clicca per selezionare immagine'),
                      onPressed: () {
                        ImagePicker.pickImage(source: ImageSource.gallery)
                            .then((file) {
                          if (file != null) {
                            path = file.path;
                            img.add(path.split('/').last);
                          } else {
                            Toast.show('Devi scegliere un\'immagine!', context,
                                duration: 3);
                          }
                        }).catchError((error) {
                          if (error is PlatformException) {
                            if (error.code == 'photo_access_denied')
                              Toast.show(
                                  'Devi garantire accesso alle immagini!',
                                  context,
                                  duration: 3);
                          }
                        });
                      },
                    ),
                    width: MediaQuery.of(context).size.width * 2 / 3,
                  );
                },
              ),
              Expanded(
                child: RaisedButton(
                  child: Text('Cambia'),
                  onPressed: () async {
                    if (path != null) {
                      if (path.split('.').last != 'jpg') {
                        Toast.show('Il formato dell\'immagine deve essere .jpg',
                            context,
                            duration: 3);
                      } else {
                        final img=widget.rest.img;
                        uploadFile(path).then((path) async {
                          Database()
                              .updateImg(
                                  path,
                                  (await UserBloc.of().outUser.first)
                                      .model
                                      .restaurantId)
                              .then((value) {
                            Toast.show('Cambiato!', context, duration: 3);
                          });
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );

    /*Scaffold(
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Stato ristorante'+(widget.rest.isDisabled?widget.rest.isDisabled.toString():'false')),
              RaisedButton(
                child: Text('Cambia'),
                onPressed: (){
                  Database().changeStatusRest(widget.rest);
                },
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                child: TextFormField(
                  key: _delKey,
                  validator: (value){
                    bool isWrong=value.contains('.');
                    if(isWrong) return 'Virgola per i decimali';
                    if(double.tryParse(value)!=null){
                      return 'Inserisci un numero';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Inserisci raggio consegne",
                  ),
                  keyboardType: TextInputType.number,
                ),
                padding: EdgeInsets.all(8.0),
              ),
              RaisedButton(
                child: Text('Cambia'),
                onPressed: ()async{
                  if(_kmKey.currentState.validate()){
                    Database().updateKm(double.parse(_kmKey.currentState.value),widget.restId);
                  }
                },
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                child: TextFormField(
                  key: _delKey,
                  validator: (value){
                    bool isWrong=value.contains('.');
                    if(isWrong) return 'Virgola per i decimali';
                    if(double.tryParse(value)!=null){
                      return 'Inserisci un numero';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Inserisci costo consegna",
                  ),
                  keyboardType: TextInputType.number,
                ),
                padding: EdgeInsets.all(8.0),
              ),
              RaisedButton(
                child: Text('Cambia'),
                onPressed: ()async{
                  if(_delKey.currentState.validate()){
                    Database().updateDeliveryFee(double.parse(_delKey.currentState.value),widget.restId);
                  }
                },
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                child: TextFormField(
                  key: _descrKey,
                  validator: (value){
                    if(value.length==0){
                      return 'Inserisci descrizione';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Inserisci una descrizione...",
                  ),
                  maxLines: 10,
                  minLines: 5,
                  keyboardType: TextInputType.text,
                ),
                padding: EdgeInsets.all(8.0),
              ),
              RaisedButton(
                child: Text('Cambia'),
                onPressed: ()async{
                  if(_descrKey.currentState.validate()){
                    Database().updateDescription(_descrKey.currentState.value,widget.restId);
                  }
                },
              )
            ],
          ),
          InkWell(
            child:Row(
              children: <Widget>[
                Icon(Icons.star),
                Icon(Icons.star),
                Text(widget.rest.averageReviews.toString()),
                Text('Buono')
              ],
            ),
            onTap: (){
              EasyRouter.push(context,SeeReviewsScreen(model: widget.rest,));
            },
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: img.stream,
                    builder: (ctx, snap) {
                      if (snap.hasData)
                        return FlatButton(
                          child: Text('Clicca per selezionare immagine'),
                          onPressed: () {
                            ImagePicker.pickImage(source: ImageSource.gallery)
                                .then((file) {
                              if (file != null) {
                                path = file.path;
                                img.add(path.split('/').last);
                              } else {
                                Toast.show(
                                    'Devi scegliere un\'immagine!', context,
                                    duration: 3);
                              }
                            }).catchError((error) {
                              if (error is PlatformException) {
                                if (error.code == 'photo_access_denied')
                                  Toast.show(
                                      'Devi garantire accesso alle immagini!',
                                      context,
                                      duration: 3);
                              }
                            });
                          },
                        );
                      return Text(snap.data);
                    },
                  ),
                  StreamBuilder(
                    stream: img.stream,
                    builder: (ctx, snap) {
                      if (snap.hasData) return Image.file(File(path));
                      return Container();
                    },
                  ),
                ],
              ),
              RaisedButton(
                child: Text('Cambia'),
                onPressed: () async{
                  if (path != null) {
                    if (path.split('.').last != 'jpg') {
                      Toast.show(
                          'Il formato dell\'immagine deve essere .jpg', context,
                          duration: 3);
                    }
                    else{
                      uploadFile(path).then((path)async{
                        Database().updateImg(path,widget.restId);
                      });
                    }
                  }
                },
              )
            ],
          ),
        ],
      ),
    );*/
    /*},
    );*/
  }
}
