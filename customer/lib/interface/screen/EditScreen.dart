import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: SnackBarPage(),
    );
  }
}

class SnackBarPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userBloc = $Provider.of<UserBloc>();
    return Scaffold(
      body: StreamBuilder<UserModel>(
        stream: userBloc.outUser,
        builder: (ctx, userSnapshot) {
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
                        child: (userSnapshot.data.imageUrl != null)
                            ? CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.imageUrl))
                            : Image(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/img/default_profile_photo.jpg"),
                              ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
              (user.nominative != null) ? Text(user.nominative) : Container(),
              const Divider(
                color: Colors.grey,
              ),
              Form(
                key: _formKey,
                child: Expanded(
                  child: ListViewSeparated(
                    separator: const Divider(
                      color: Colors.grey,
                    ),
                    children: <Widget>[
                      TextFormField(
                        key: _nameKey,
                        initialValue: user.nominative,
                        style: theme.textTheme.subhead,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo invalido';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        key: _emailKey,
                        initialValue: user.email,
                        style: theme.textTheme.subhead,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo invalido';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password corrente',
                        ),
                        style: theme.textTheme.subhead,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Inserire la password corrente';
                          }
                          return null;
                        },
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              await userBloc.updateNominativeAndEmail(_passwordController.text, _nameKey.currentState.value.toString(), _nameKey.currentState.value.toString());
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Cambiamenti eseguiti!'),
                              ));
                            } catch (error) {
                              print(error);
                              if (error.code == 'ERROR_INVALID_EMAIL') {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('E-mail non valida'),
                                ));
                              } else if (error.code == 'ERROR_WRONG_PASSWORD') {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Password fornita non corretta'),
                                ));
                              } else
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Ci sono stati degli errori'),
                                ));
                            }
                          }
                        },
                        child: FittedText('Aggiorna dati'),
                      ),
                    ].map((child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0 * 2),
                        child: child,
                      );
                    }).toList(),
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
