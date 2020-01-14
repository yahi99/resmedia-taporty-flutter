import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

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
            builder: (ctx, userModelSnapshot) {
              if (snap.hasData && userModelSnapshot.hasData) {
                var user = userModelSnapshot.data;
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
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: Container(
                            width: 190.0,
                            height: 190.0,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: (user.imageUrl != null)
                                  ? CircleAvatar(backgroundColor: Colors.white, backgroundImage: CachedNetworkImageProvider(user.imageUrl))
                                  : Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage("assets/img/default_profile_photo.jpg"),
                                    ),
                            ),
                          ),
                        ),
                        /*Padding(
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
                                    Database().updateUserImage(path, user.id, user.imageUrl).then((value) {
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
                        ),*/
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: ListViewSeparated(
                        separator: const Divider(
                          color: Colors.grey,
                        ),
                        children: <Widget>[
                          Text(
                            user.customerName,
                            style: theme.textTheme.subhead,
                          ),
                          Text(
                            user.address,
                            style: theme.textTheme.subhead,
                          ),
                          Text(
                            user.email,
                            style: theme.textTheme.subhead,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.settings),
                              FlatButton(
                                  child: Text('Log Out', style: theme.textTheme.subhead),
                                  onPressed: () {
                                    UserBloc.of().logout();
                                    LoginHelper().signOut();
                                    EasyRouter.pop(context);
                                  }),
                            ],
                          ),
                        ].map((child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0 * 2),
                            child: child,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
