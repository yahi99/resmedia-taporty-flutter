import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:toast/toast.dart';

class EditAccountScreen extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccountScreen> {
  final userBloc = $Provider.of<UserBloc>();

  final _formKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _passwordController = TextEditingController();

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
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        ...[
                          TextFormField(
                            key: _nameKey,
                            decoration: InputDecoration(
                              labelText: 'Nome',
                            ),
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
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            initialValue: user.email,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Campo invalido';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            key: _phoneKey,
                            decoration: InputDecoration(
                              labelText: 'Numero di telefono',
                            ),
                            keyboardType: TextInputType.phone,
                            initialValue: user.phoneNumber,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Campo invalido';
                              }
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
                          // TODO: Mettere un controllo sul Provider di autenticazione: se non è email e password serve la reautenticazioni con quel provider (provider nell'UserBloc)
                          Text("Per aggiornare i dati è necessario reinserire la password dell'account."),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password corrente',
                            ),
                            obscureText: true,
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
                                  await userBloc.updateUserInfo(
                                      _passwordController.text, _nameKey.currentState.value.toString(), _emailKey.currentState.value.toString(), _phoneKey.currentState.value.toString());
                                  Toast.show('Cambiamenti eseguiti!', context);
                                } catch (error) {
                                  print(error);
                                  if (error.code == 'ERROR_INVALID_EMAIL') {
                                    Toast.show('E-mail non valida', context);
                                  } else if (error.code == 'ERROR_WRONG_PASSWORD') {
                                    Toast.show('Password fornita non corretta', context);
                                  } else
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
