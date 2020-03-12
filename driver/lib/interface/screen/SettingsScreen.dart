import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:toast/toast.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final driverBloc = $Provider.of<DriverBloc>();
  final _formKey = GlobalKey<FormState>();
  final _ibanKey = GlobalKey<FormFieldState>();

  static final RegExp ibanRegExp = new RegExp(r"^[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{4}[0-9]{7}([a-zA-Z0-9]?){0,16}$");

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modifica dell'account",
          style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
        ),
      ),
      body: StreamBuilder<DriverModel>(
        stream: driverBloc.outDriver,
        builder: (ctx, driverSnap) {
          if (!driverSnap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          var driver = driverSnap.data;

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
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Form(
                key: _formKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ...[
                          TextFormField(
                            key: _ibanKey,
                            decoration: InputDecoration(
                              labelText: 'IBAN',
                            ),
                            initialValue: driver.iban,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'IBAN non valido';
                              }
                              if (!ibanRegExp.hasMatch(value.replaceAll(" ", ""))) return 'IBAN non valido';
                              return null;
                            },
                          ),
                        ].map((child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            child: child,
                          );
                        }).toList(),
                        Divider(),
                        ...[
                          RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  await driverBloc.updateIBAN(_ibanKey.currentState.value.toString().replaceAll(" ", ""));

                                  Toast.show('Cambiamenti eseguiti!', context);
                                  Navigator.pop(context);
                                } catch (error) {
                                  print(error);
                                  Toast.show('Ci sono stati degli errori', context);
                                }
                              }
                            },
                            child: FittedText('Aggiorna dati'),
                          ),
                        ].map((child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            child: child,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
