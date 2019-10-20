import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:toast/toast.dart';

class BecomeRestaurantScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'AccountScreenDriver';

  String get route => ROUTE;

  @override
  State<BecomeRestaurantScreen> createState() => new NewDriverState();
}

/*TODO:
bisogna fare in modo che quando una richiesta viene accettata viene creato un ristorante
con lat e lng : al posto del campo indirizzo un inserimento dal search di google
img: upload dal cellulare dell'immagine del ristorante con modifica della visualizzazione
 da cliente e copertura chilometrica
 */

class NewDriverState extends State<BecomeRestaurantScreen> {
  final _formKey = new GlobalKey<FormState>();
  final _ragKey = new GlobalKey<FormFieldState>();
  final _ivaKey = new GlobalKey<FormFieldState>();
  final _indKey = new GlobalKey<FormFieldState>();
  final _eseKey = new GlobalKey<FormFieldState>();
  final _prodKey = new GlobalKey<FormFieldState>();

  FocusNode _ragNode;
  FocusNode _ivaNode;
  FocusNode _indNode;
  FocusNode _eseNode;
  FocusNode _prodNode;

  @override
  void initState() {
    _ragNode = new FocusNode();
    _ivaNode = new FocusNode();
    _indNode = new FocusNode();
    _eseNode = new FocusNode();
    _prodNode = new FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _ragNode.dispose();
    _ivaNode.dispose();
    _indNode.dispose();
    _eseNode.dispose();
    _prodNode.dispose();
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
        title: Text("Diventa un Ristoratore"),
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
                              key: _ragKey,
                              focusNode: _ragNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _ragNode, _ivaNode),
                              validator: (value){
                                if(value.length!=16){
                                  return 'Inserisci ragione sociale';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Ragione sociale",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _ivaKey,
                              focusNode: _ivaNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _ivaNode, _indNode),
                              decoration: InputDecoration(
                                hintText: "Partita iva",
                              ),
                              validator: (value){
                                if(value.length==0){
                                  return 'Inserisci partita iva';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _indKey,
                              focusNode: _indNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _indNode, _eseNode),
                              decoration: InputDecoration(
                                hintText: "Indirizzo",
                              ),
                              validator: (value){
                                if(value.length==0){
                                  return 'Inserisci indirizzo';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _eseKey,
                              focusNode: _eseNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _eseNode, _prodNode),
                              decoration: InputDecoration(
                                hintText: "Tipologia esercizio",
                              ),
                              validator: (value){
                                if(value.length==0){
                                  return 'Inserisci tipologia';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _prodKey,
                              focusNode: _prodNode,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                _prodNode.unfocus();
                                //_upgrade(snap.data.model.id,context);
                                // update DB
                              },
                              validator: (value){
                                if(value.length==0){
                                  return 'Inserisci categoria';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Categoria merce",
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
                        //_upgrade(snap.data.model.id,context);
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
