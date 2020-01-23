import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/screen/EditScreen.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/blocs/OrderBloc.dart';

class AccountScreen extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userBloc = $Provider.of<UserBloc>();
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
      body: StreamBuilder<UserModel>(
        stream: userBloc.outUser,
        builder: (_, userSnapshot) {
          if (!userSnapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          var user = userSnapshot.data;
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
                  Padding(
                    padding: EdgeInsets.only(top: 25.0, left: 140.0),
                    child: IconButton(
                      iconSize: 50.0,
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
                          if (imageFile != null) {
                            await userBloc.updateProfileImage(imageFile);
                            Toast.show('Immagine di profilo cambiata', context, duration: 3);
                          }
                        } catch (err) {
                          if (err.code == 'photo_access_denied')
                            Toast.show('Accesso alla galleria non fornito.', context, duration: 3);
                          else
                            Toast.show('Errore inaspettato.', context, duration: 3);
                        }
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
              user.nominative != null ? Text(user.nominative) : Container(),
              const Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: ListViewSeparated(
                  separator: const Divider(
                    color: Colors.grey,
                  ),
                  children: <Widget>[
                    (user.email != null)
                        ? Text(
                            user.email,
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
                            // TODO: Sistemare
                            await $Provider.of<OrderBloc>().setUserStream(user.id);
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
                          onPressed: () async {
                            await _auth.signOut();
                            Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
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
        },
      ),
    );
  }
}
