import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';

class AccountScreen extends StatelessWidget {
  //final _stripeBloc = $Provider.of<StripeBloc>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final driverBloc = $Provider.of<DriverBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
        ),
      ),
      body: StreamBuilder<DriverModel>(
        stream: driverBloc.outDriver,
        builder: (_, driverSnapshot) {
          if (!driverSnapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          var driver = driverSnapshot.data;

          Widget imageWidget = Image(
            fit: BoxFit.cover,
            image: AssetImage("assets/img/default_profile_photo.jpg"),
          );

          if (driver.imageUrl != null && driver.imageUrl != "") {
            imageWidget = CachedNetworkImage(
              imageUrl: driver.imageUrl,
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
                    Text(
                      driver.iban,
                      style: theme.textTheme.subhead,
                    ),
                    /*StreamBuilder<bool>(
                        stream: _stripeBloc.outLinkCreationLoading,
                        builder: (context, snapshot) {
                          var isLoading = snapshot.data ?? false;
                          return Row(
                            children: <Widget>[
                              Icon(Icons.euro_symbol),
                              FlatButton(
                                child: Text('Gestione pagamenti', style: theme.textTheme.subhead),
                                onPressed: isLoading
                                    ? null
                                    : () async {
                                        try {
                                          await _stripeBloc.openStripeConsole();
                                        } on StripeLinkException catch (err) {
                                          Toast.show(err.message, context);
                                        } catch (err) {
                                          Toast.show("Errore inaspettato. Riprova più tardi.", context);
                                        }
                                      },
                              ),
                              if (isLoading)
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),*/
                    Row(
                      children: <Widget>[
                        Icon(Icons.settings),
                        FlatButton(
                          child: Text('Impostazioni', style: theme.textTheme.subhead),
                          onPressed: () async {
                            Navigator.pushNamed(context, "/settings");
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.exit_to_app),
                        FlatButton(
                          child: Text('Log Out', style: theme.textTheme.subhead),
                          onPressed: () async {
                            await driverBloc.signOut();
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
