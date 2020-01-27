import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';

class AccountScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final driverBloc = $Provider.of<DriverBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: StreamBuilder<DriverModel>(
        stream: driverBloc.outDriver,
        builder: (_, driverSnapshot) {
          if (!driverSnapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          var driver = driverSnapshot.data;
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
                        child: (driver.imageUrl != null)
                            ? CircleAvatar(backgroundColor: Colors.white, backgroundImage: CachedNetworkImageProvider(driver.imageUrl))
                            : Image(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/img/default_profile_photo.jpg"),
                              ),
                      ),
                    ),
                  ),
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
                      driver.nominative,
                      style: theme.textTheme.subhead,
                    ),
                    Text(
                      driver.address,
                      style: theme.textTheme.subhead,
                    ),
                    Text(
                      driver.email,
                      style: theme.textTheme.subhead,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.settings),
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
            ],
          );
        },
      ),
    );
  }
}
