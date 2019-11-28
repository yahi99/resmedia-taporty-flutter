import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/HomeScreenPanel.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/ProductBloc.dart';
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
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:toast/toast.dart';

import 'ManageSpecificRestaurant.dart';
import 'ManageSpecificUser.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ManageProduct extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ManageProduct";

  final ProductBloc prod;
  final bool isFood;

  ManageProduct({@required this.prod,@required this.isFood});

  String get route => ROUTE;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ManageProduct> {
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
    file.writeAsBytes(bytes, mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(file);
    final Uri downloadUrl = (await task.onComplete).uploadSessionUri;

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
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestisci prodotto"),
        actions: <Widget>[],
      ),
      body: StreamBuilder<FoodModel>(
        stream: widget.prod.outRequests,
        builder: (ctx,snapshot){
          print(snapshot.data);
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Text(
                        'Disabilitato: ' + (snapshot.data.isDisabled ? 'Si' : 'No')),
                    width: MediaQuery.of(context).size.width * 2 / 3,
                    padding: EdgeInsets.all(16.0),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text('Cambia'),
                      onPressed: () {
                        Database().changeStatus(snapshot.data);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(child:Text('Prezzo: ' + snapshot.data.price + ' euro'),padding:EdgeInsets.all(8.0)),
                        Padding(
                          child: TextFormField(
                            key: _delKey,
                            validator: (value) {
                              bool isWrong = value.contains(',');
                              if (isWrong) return 'Punto per i decimali';
                              if (double.tryParse(value) == null) {
                                return 'Inserisci un numero';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Inserisci prezzo",
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    padding: EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width*2/3,
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text('Cambia'),
                      onPressed: () async {
                        if (_delKey.currentState.validate()) {
                          Database().updateProductPrice(
                              double.tryParse(_delKey.currentState.value),
                              snapshot.data);
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
                            final imgPath=(await widget.prod.outRequests.first).img;
                            uploadFile(path).then((path) async {
                              Database()
                                  .updateImgProduct(path, snapshot.data,imgPath)
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
          );
        },
      )
    );
  }
}
