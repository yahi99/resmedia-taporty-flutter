import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:toast/toast.dart';

class BecomeDriverScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'AccountScreenDriver';

  String get route => ROUTE;

  @override
  State<BecomeDriverScreen> createState() => new NewDriverState();
}

class NewDriverState extends State<BecomeDriverScreen> {
  final _formKey = new GlobalKey<FormState>();
  final _fiscKey = new GlobalKey<FormFieldState>();
  final _resKey = new GlobalKey<FormFieldState>();
  final _copKey = new GlobalKey<FormFieldState>();
  final _carKey = new GlobalKey<FormFieldState>();
  final _expKey = new GlobalKey<FormFieldState>();

  FocusNode _fiscNode;
  FocusNode _resNode;
  FocusNode _copNode;
  FocusNode _carNode;
  FocusNode _expNode;

  @override
  void initState() {
    _fiscNode = new FocusNode();
    _resNode = new FocusNode();
    _copNode = new FocusNode();
    _carNode = new FocusNode();
    _expNode = new FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _fiscNode.dispose();
    _resNode.dispose();
    _copNode.dispose();
    _carNode.dispose();
    _expNode.dispose();
    super.dispose();
  }

  bool _upgrade(String uid,BuildContext context){
    if(_formKey.currentState.validate()) {
      //Can add all the data that is required in the future
      Database().upgradeToDriver(uid: uid).then((value){
        Toast.show('Richiesta andata a buon fine!', context,duration: 3);
      });
    }
  }

  void _changeFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = UserBloc.of();
    return Scaffold(
      appBar: AppBar(
        title: Text("Diventa un Fattorino"),
      ),
      body: StreamBuilder<User>(
        stream: user.outUser,
        builder: (ctx, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      child: Text(
                        snap.data.model.nominative,
                        style: theme.textTheme.subhead,
                      ),
                      padding: EdgeInsets.all(8.0),
                    ),
                    Padding(
                      child: Text(
                        snap.data.model.email,
                        style: theme.textTheme.subhead,
                      ),
                      padding: EdgeInsets.all(8.0),
                    ),
                    Form(
                      autovalidate: false,
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            child: TextFormField(
                              key: _fiscKey,
                              focusNode: _fiscNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _fiscNode, _resNode),
                              validator: (value){
                                if(value.length!=16){
                                  return 'Inserisci codice fiscale';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Codice fiscale",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _resKey,
                              focusNode: _resNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _resNode, _copNode),
                              decoration: InputDecoration(
                                hintText: "Residenza/Domicilio",
                              ),
                              validator: (value){
                                if(value.length==0){
                                  return 'Inserisci residenza';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _copKey,
                              focusNode: _copNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _copNode, _carNode),
                              decoration: InputDecoration(
                                hintText: "Copertura in Km",
                              ),
                              validator: (value){
                                if(value.length==0){
                                  return 'Inserisci copertura';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _carKey,
                              focusNode: _carNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _carNode, _expNode),
                              decoration: InputDecoration(
                                hintText: "Mezzo utilizzato",
                              ),
                              validator: (value){
                                if(value.length==0){
                                  return 'Inserisci mezzo';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _expKey,
                              focusNode: _expNode,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                _expNode.unfocus();
                                _upgrade(snap.data.model.id,context);
                                // update DB
                              },
                              validator: (value){
                                if(value.length==0){
                                  return 'Inserisci descrizione';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Esperienze, CV, ecc...",
                              ),
                              maxLines: 10,
                              minLines: 5,
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      child: Text('  Invia Richiesta  '),
                      onPressed: (){
                        //update DB
                        _upgrade(snap.data.model.id,context);
                      },
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
