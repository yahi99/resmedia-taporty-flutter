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
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:toast/toast.dart';

class EditRestScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'EditRestScreen';

  @override
  String get route => ROUTE;

  @override
  _TurnWorkTabDriverState createState() => _TurnWorkTabDriverState();
}

class _TurnWorkTabDriverState extends State<EditRestScreen> {
  StreamController img;

  String path, _path;

  final _descrKey = new GlobalKey<FormFieldState>();
  final _delKey = new GlobalKey<FormFieldState>();
  final _kmKey = new GlobalKey<FormFieldState>();

  Future<String> uploadFile(String filePath) async {
    //final Uint8List bytes = File(filePath).readAsBytesSync();
    final Uint8List bytes = File(filePath).readAsBytesSync();
    final Directory tempDir = Directory.systemTemp;
    final String fileName = filePath.split('/').last;
    final File file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);

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
      appBar: AppBar(
        title: Text('Modifica dati ristorante'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
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
                        uploadFile(path).then((path) async {
                          Database()
                              .updateRestaurantImage(
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
    /*},
    );*/
  }
}
