import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/BecomeDriverScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/BecomeRestaurantScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/ChangePasswordScreeen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/EditScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/LegalNotesScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/OrderScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/SettingsScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:toast/toast.dart';

class AccountScreen extends StatelessWidget implements WidgetRoute {
  static const ROUTE = 'AccountScreen';

  String get route => ROUTE;

  Future<String> uploadFile(String filePath) async {
    final Uint8List bytes = File(filePath).readAsBytesSync();
    final Directory tempDir = Directory.systemTemp;
    final String fileName = filePath.split('/').last;
    final File file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    return (await ref.getDownloadURL());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = UserBloc.of();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () => {EasyRouter.push(context, EditScreen())},
            icon: Icon(Icons.mode_edit),
          )
        ],
        title: Text("Account"),
      ),
      body: StreamBuilder<User>(
        stream: user.outUser,
        builder: (ctx, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return StreamBuilder(
              stream: Database().getUser(snap.data.userFb),
              builder: (ctx, model) {
                if (snap.hasData && model.hasData) {
                  if (model.data.type != 'user' && model.data.type != null) {
                    return RaisedButton(
                      child: Text('Sei stato disabilitato clicca per fare logout'),
                      onPressed: () {
                        UserBloc.of().logout();
                        LoginHelper().signOut();
                        EasyRouter.pushAndRemoveAll(context, LoginScreen());
                        //UserBloc.close();
                      },
                    );
                  }
                  print(snap.data.model.isDriver);
                  //var temp = snap.data.model.nominative.split(' ');
                  return Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 3,
                            child: Image.asset(
                              "assets/img/home/etnici.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          StreamBuilder<UserModel>(
                            stream: Database().getUserModelById(snap.data.model.id),
                            builder: (ctx, img) {
                              if (!img.hasData)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              return Padding(
                                padding: EdgeInsets.only(top: 25.0),
                                child: Container(
                                  width: 190.0,
                                  height: 190.0,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: (img.data.img != null)
                                        ? CircleAvatar(backgroundImage: CachedNetworkImageProvider(img.data.img))
                                        : CircleAvatar(
                                            backgroundColor: Colors.black,
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 25.0, left: 140.0),
                            child: IconButton(
                              iconSize: 50.0,
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                                  if (file != null) {
                                    uploadFile(file.path).then((path) async {
                                      Database().updateUserImage(path, snap.data.model.id, snap.data.model.img).then((value) {
                                        Toast.show('Cambiato!', context, duration: 3);
                                      });
                                    });
                                  } else {
                                    Toast.show('Devi scegliere un\'immagine!', context, duration: 3);
                                  }
                                }).catchError((error) {
                                  if (error is PlatformException) {
                                    if (error.code == 'photo_access_denied') Toast.show('Devi garantire accesso alle immagini!', context, duration: 3);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      snap.data.model.nominative != null ? Text(snap.data.model.nominative) : Container(),
                      (snap.data.model.lat != null && snap.data.model.lng != null)
                          ? StreamBuilder<List<Address>>(
                              stream: Geocoder.local.findAddressesFromCoordinates(Coordinates(snap.data.model.lat, snap.data.model.lng)).asStream(),
                              builder: (ctx, loc) {
                                if (loc.hasData) return Text(loc.data.first.addressLine);
                                return Container();
                              },
                            )
                          : Container(),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: ListViewSeparated(
                          separator: const Divider(
                            color: Colors.grey,
                          ),
                          children: <Widget>[
                            (snap.data.model.email != null)
                                ? Text(
                                    snap.data.model.email,
                                    style: theme.textTheme.subhead,
                                  )
                                : Container(),
                            Row(
                              children: <Widget>[
                                Icon(Icons.directions_car),
                                FlatButton(
                                  child: Text('Diventa un Fattorino', style: theme.textTheme.subhead),
                                  onPressed: () => {EasyRouter.push(context, BecomeDriverScreen())},
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.directions_car),
                                FlatButton(
                                  child: Text('Diventa un ristoratore', style: theme.textTheme.subhead),
                                  onPressed: () => {EasyRouter.push(context, BecomeRestaurantScreen())},
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.shopping_cart),
                                FlatButton(
                                  child: Text('Lista ordini', style: theme.textTheme.subhead),
                                  onPressed: () async {
                                    await OrdersBloc.of().setUserStream();
                                    EasyRouter.push(context, OrderScreen());
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.insert_drive_file),
                                FlatButton(
                                  child: Text('Note legali', style: theme.textTheme.subhead),
                                  onPressed: () => {EasyRouter.push(context, LegalNotesScreen())},
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.lock_outline),
                                FlatButton(
                                  child: Text('Cambia password', style: theme.textTheme.subhead),
                                  onPressed: () => {EasyRouter.push(context, ChangePasswordScreen())},
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.settings),
                                FlatButton(
                                  child: Text('Settings', style: theme.textTheme.subhead),
                                  onPressed: () => {EasyRouter.push(context, SettingsScreen())},
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.settings),
                                FlatButton(
                                    child: Text('Log Out', style: theme.textTheme.subhead),
                                    onPressed: () {
                                      user.logout().then((onValue) {
                                        LoginHelper().signOut();
                                        EasyRouter.pushAndRemoveAll(context, LoginScreen());
                                        //UserBloc.close();
                                      });
                                    }),
                              ],
                            ),
                          ].map((child) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: SPACE * 2),
                              child: child,
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
        },
      ),
    );
  }
}
