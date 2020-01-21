import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/screen/EditScreen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatelessWidget {
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
    final user = $Provider.of<UserBloc>();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditScreen(),
              ),
            ),
            icon: Icon(Icons.mode_edit),
          )
        ],
        title: Text("Account"),
      ),
      body: StreamBuilder<User>(
        stream: user.outUser,
        builder: (ctx, userSnapshot) {
          if (!userSnapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return StreamBuilder<UserModel>(
              stream: Database().getUser(userSnapshot.data.userFb),
              builder: (ctx, userModelSnapshot) {
                if (userSnapshot.hasData && userModelSnapshot.hasData) {
                  if (userModelSnapshot.data.type != 'user' && userModelSnapshot.data.type != null) {
                    return RaisedButton(
                      child: Text('Sei stato disabilitato clicca per fare logout'),
                      onPressed: () {
                        $Provider.of<UserBloc>().logout();
                        LoginHelper().signOut();
                        Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                        //UserBloc.close();
                      },
                    );
                  }
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
                          Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: Container(
                              width: 190.0,
                              height: 190.0,
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: (userModelSnapshot.data.imageUrl != null)
                                    ? CircleAvatar(backgroundColor: Colors.white, backgroundImage: CachedNetworkImageProvider(userModelSnapshot.data.imageUrl))
                                    : Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage("assets/img/default_profile_photo.jpg"),
                                      ),
                              ),
                            ),
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
                                      Database().updateUserImage(path, userSnapshot.data.model.id, userSnapshot.data.model.imageUrl).then((value) {
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
                      userSnapshot.data.model.nominative != null ? Text(userSnapshot.data.model.nominative) : Container(),
                      const Divider(
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: ListViewSeparated(
                          separator: const Divider(
                            color: Colors.grey,
                          ),
                          children: <Widget>[
                            (userSnapshot.data.model.email != null)
                                ? Text(
                                    userSnapshot.data.model.email,
                                    style: theme.textTheme.subhead,
                                  )
                                : Container(),
                            Row(
                              children: <Widget>[
                                Icon(Icons.directions_car),
                                FlatButton(
                                  child: Text('Diventa un Fattorino', style: theme.textTheme.subhead),
                                  onPressed: () async {
                                    var url = "https://taporty-requests.firebaseapp.com/?type=driver";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.directions_car),
                                FlatButton(
                                  child: Text('Diventa un ristoratore', style: theme.textTheme.subhead),
                                  onPressed: () async {
                                    var url = "https://taporty-requests.firebaseapp.com/?type=supplier";
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.shopping_cart),
                                FlatButton(
                                  child: Text('Lista ordini', style: theme.textTheme.subhead),
                                  onPressed: () async {
                                    await $Provider.of<OrderBloc>().setUserStream(userSnapshot.data.userFb.uid);
                                    Navigator.pushNamed(context, "/orderList");
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.insert_drive_file),
                                FlatButton(
                                  child: Text('Note legali', style: theme.textTheme.subhead),
                                  onPressed: () => Navigator.pushNamed(context, "/legalNotes"),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.lock_outline),
                                FlatButton(
                                  child: Text('Cambia password', style: theme.textTheme.subhead),
                                  onPressed: () => Navigator.pushNamed(context, "/changePassword"),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.settings),
                                FlatButton(
                                  child: Text('Impostazioni', style: theme.textTheme.subhead),
                                  onPressed: () => Navigator.pushNamed(context, "/settings"),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.exit_to_app),
                                FlatButton(
                                  child: Text('Log Out', style: theme.textTheme.subhead),
                                  onPressed: () {
                                    user.logout().then(
                                      (onValue) {
                                        LoginHelper().signOut();
                                        Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                                      },
                                    );
                                  },
                                ),
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
