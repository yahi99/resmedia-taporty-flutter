import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/screen/SupplierListScreen.dart';
import 'package:toast/toast.dart';

class GeolocalizationScreen extends StatefulWidget {
  GeolocalizationScreen();

  @override
  _GeolocalizationScreenState createState() => _GeolocalizationScreenState();
}

class _GeolocalizationScreenState extends State<GeolocalizationScreen> {
  // TODO: Capire a cosa serve e spostarla nelle variabili globali
  static final String _key = 'AIzaSyAmJyflDR6W10z738vMkLz9Oham51HR790';

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _key);

  TextEditingController _controller = TextEditingController();

  var isValid = false;
  GeoPoint customerCoordinates;
  String customerAddress;

  // ignore: close_sinks
  final geo = StreamController<String>();

  void _focusNodePlaces() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: _key,
      language: "it",
      hint: "Cerca",
    );
    displayPrediction(p);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);

      //var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      customerCoordinates = GeoPoint(lat, lng);

      customerAddress = p.description;

      isValid = true;

      geo.sink.add(customerAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamBuilder<String>(
        stream: geo.stream,
        builder: (ctx, snap) {
          if (snap.hasData) _controller.value = TextEditingValue(text: snap.data);
          return LogoView(
              top: FittedBox(
                fit: BoxFit.contain,
                child: Icon(
                  Icons.lock_open,
                  color: Colors.white,
                ),
              ),
              children: <Widget>[
                TextField(
                  controller: _controller,
                  onTap: _focusNodePlaces,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white70,
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(const Radius.circular(15.0)),
                    ),
                    suffixIcon: Icon(
                      Icons.location_on,
                    ),
                    hintText: 'Via Mario Rossi',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(Icons.check),
                      color: Colors.blue,
                      onPressed: () async {
                        if (isValid) {
                          var user = (await $Provider.of<UserBloc>().outUser.first).model;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupplierListScreen(
                                customerCoordinates: customerCoordinates,
                                customerAddress: customerAddress,
                                isAnonymous: false,
                                user: user,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          Toast.show('Inserire un indirizzo valido', context);
                        }
                      },
                    ),
                  ],
                ),
              ]);
        },
      ),
    );
  }
}
