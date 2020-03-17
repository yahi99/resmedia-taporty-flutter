import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userBloc = $Provider.of<UserBloc>();
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/editAccount"),
            icon: Icon(Icons.mode_edit),
          )
        ],
        title: Text(
          "Account",
          style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
        ),
      ),
      body: StreamBuilder<String>(
        stream: userBloc.outAuthProviderId,
        builder: (_, providerIdSnap) {
          return StreamBuilder<UserModel>(
            stream: userBloc.outUser,
            builder: (_, userSnapshot) {
              if (!userSnapshot.hasData || !providerIdSnap.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );

              var user = userSnapshot.data;
              var providerId = providerIdSnap.data;

              Widget imageWidget = Image(
                fit: BoxFit.cover,
                image: AssetImage("assets/img/default_profile_photo.jpg"),
              );

              if (user.imageUrl != null && user.imageUrl != "") {
                imageWidget = CachedNetworkImage(
                  imageUrl: user.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => imageWidget,
                );
              }
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: imageWidget,
                          ),
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
                        Text(
                          user.email,
                          style: theme.textTheme.subhead,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.shopping_cart),
                            FlatButton(
                              child: Text('Lista ordini', style: theme.textTheme.subhead),
                              onPressed: () {
                                Navigator.pushNamed(context, "/orderList");
                              },
                            ),
                          ],
                        ),
                        /*Row(
                          children: <Widget>[
                            Icon(Icons.insert_drive_file),
                            FlatButton(
                              child: Text('Note legali', style: theme.textTheme.subhead),
                              onPressed: () => Navigator.pushNamed(context, "/legalNotes"),
                            ),
                          ],
                        ),*/
                        if (providerId == EmailAuthProvider.providerId)
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
                              child: Text('Esci', style: theme.textTheme.subhead),
                              onPressed: () async {
                                await userBloc.signOut();
                                Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: InkWell(
                            child: Text(
                              "Lavora con noi",
                              style: TextStyle(color: ColorTheme.BLUE),
                            ),
                            onTap: () async {
                              var url = "https://taporty-requests.firebaseapp.com/?type=supplier";
                              if (await canLaunch(url)) {
                                await launch(url);
                              }
                            },
                          ),
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
          );
        },
      ),
    );
  }
}
