import 'dart:async';

import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
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

  static final String _key = 'AIzaSyAmJyflDR6W10z738vMkLz9Oham51HR790';

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _key);

  TextEditingController _controller = TextEditingController();

  Position pos;
  String address;
  bool isValid=false;

  StreamController geo;

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
    geo = StreamController<String>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    _fiscNode.dispose();
    _resNode.dispose();
    _copNode.dispose();
    _carNode.dispose();
    _expNode.dispose();
    geo.close();
    super.dispose();
  }

  void _focusNodePlaces() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p =
    await PlacesAutocomplete.show(context: context, apiKey: _key);
    displayPrediction(p);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      //var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      pos = Position(latitude: lat, longitude: lng);

      address = p.description;

      isValid = true;

      geo.sink.add(address);
    }
  }

  Future<void> _upgrade(String uid,BuildContext context,String nominative){
    if(_formKey.currentState.validate()) {
      //Can add all the data that is required in the future
      Database().upgradeToDriver(uid: uid,car: _carKey.currentState.value,
          codiceFiscale: _fiscKey.currentState.value,address: _resKey.currentState.value,
          km: double.tryParse(_copKey.currentState.value),exp:_expKey.currentState.value,
          pos: pos,nominative: nominative).then((value){
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
                          StreamBuilder<String>(
                            stream: geo.stream,
                            builder: (ctx, snap) {
                              if (snap.hasData)
                                _controller.value =
                                    TextEditingValue(text: snap.data);
                              return Padding(
                                child: TextFormField(
                                  controller: _controller,
                                  onTap: _focusNodePlaces,
                                  key: _resKey,
                                  focusNode: _resNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) =>
                                      _changeFocus(context, _resNode, _copNode),
                                  decoration: InputDecoration(
                                    hintText: "Indirizzo",
                                  ),
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return 'Inserisci indirizzo';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                                padding: EdgeInsets.all(8.0),
                              );
                            },
                          ),
                          /*Padding(
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
                          ),*/
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
                                _upgrade(snap.data.model.id,context,snap.data.model.nominative);
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
                      child: Padding(child:Text('Invia Richiesta'),padding: EdgeInsets.all(SPACE),),
                      onPressed: (){
                        //update DB
                        _upgrade(snap.data.model.id,context,snap.data.model.nominative);
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
