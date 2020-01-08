import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/GeolocalizationScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/widget/SearchBar.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';

import '../../../main.dart';

class RestaurantListScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'RestaurantListScreen';

  String get route => ROUTE;
  final UserModel user;
  final GeoPoint customerCoordinates;
  final String customerAddress;
  final bool isAnonymous;

  RestaurantListScreen({Key key, @required this.user, @required this.customerCoordinates, @required this.customerAddress, @required this.isAnonymous}) : super(key: key);

  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final double iconSize = 32;

  BuildContext dialog;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  StreamController searchBarStream;

  final UserBloc userBloc = UserBloc.of();
  final RestaurantsBloc _restaurantsBloc = RestaurantsBloc.instance();

  void showNotification(BuildContext context, Map<String, dynamic> message) async {
    print('Build dialog');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message['notification']['title']),
          subtitle: Text(message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();
    print('ok');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        if (dialog != null) showNotification(dialog, message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    RestaurantsBloc.close();
    searchBarStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchBarStream = new StreamController<String>.broadcast();
    firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    dialog = context;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.public),
          onPressed: () {
            EasyRouter.push(context, GeoLocScreen(isAnonymous: false));
          },
        ),
        title: Text('Ristoranti nella tua zona'),
        backgroundColor: ColorTheme.RED,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              EasyRouter.push(context, AccountScreen());
            },
          ),
        ],
        bottom: SearchBar(
          searchBarStream: searchBarStream,
        ),
      ),
      body: CacheStreamBuilder<List<RestaurantModel>>(
          stream: _restaurantsBloc.outRestaurants,
          builder: (context, AsyncSnapshot<List<RestaurantModel>> restaurantListSnapshot) {
            return StreamBuilder<User>(
              stream: UserBloc.of().outUser,
              builder: (context, userSnapshot) {
                if (!restaurantListSnapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return StreamBuilder<String>(
                  stream: searchBarStream.stream,
                  builder: (context, searchBarSnapshot) {
                    return StreamBuilder(
                      stream: Database().getUser(userSnapshot.data.userFb),
                      builder: (context, userModelSnapshot) {
                        if (restaurantListSnapshot.hasData && userSnapshot.hasData && userModelSnapshot.hasData) {
                          if (userModelSnapshot.data.type != 'user' && userModelSnapshot.data.type != null) {
                            return RaisedButton(
                              child: Text('Sei stato disabilitato clicca per fare logout'),
                              onPressed: () {
                                UserBloc.of().logout();
                                LoginHelper().signOut();
                                EasyRouter.pushAndRemoveAll(context, LoginScreen());
                              },
                            );
                          }

                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildRestaurantListView(restaurantListSnapshot.data, searchBarSnapshot),
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  },
                );
              },
            );
          }),
    );
  }

  _buildRestaurantListView(var restaurantList, var searchBarSnapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: restaurantList.length,
      itemBuilder: (context, int index) {
        //final distance=Distance();
        if (searchBarSnapshot.hasData && !restaurantList[index].id.toLowerCase().contains(searchBarSnapshot.data.toLowerCase())) return Container();
        var stream;
        if (restaurantList[index].getPos() != null && widget.customerCoordinates != null) {
          final LatLng start = restaurantList[index].getPos();
          final LatLng end = LatLng(widget.customerCoordinates.latitude, widget.customerCoordinates.longitude);
          stream = userBloc.getDistance(start, end).asStream();
          // TODO: Rimuovere l'else che permette un comportamento scorretto.
        } else
          stream = userBloc.getMockDistance().asStream();
        return StreamBuilder<double>(
            stream: stream,
            builder: (ctx, snap) {
              if (!snap.hasData) return Container();
              // TODO: Ripristinare a tempo debito.
              // if(snap.data/1000<restaurantList[index].km) {
              if (restaurantList[index].isDisabled != null && restaurantList[index].isDisabled) return Container();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () async {
                    EasyRouter.push(
                      context,
                      RestaurantScreen(
                        restaurantAddress: (await Geocoder.local.findAddressesFromCoordinates(new Coordinates(restaurantList[index].coordinates.latitude, restaurantList[index].coordinates.longitude)))
                            .first
                            .addressLine,
                        customerCoordinates: widget.customerCoordinates,
                        customerAddress: widget.customerAddress,
                        restaurantModel: restaurantList[index],
                      ),
                    );
                  },
                  child: RestaurantView(
                    model: restaurantList[index],
                  ),
                ),
              );
            });
      },
    );
  }
}

class RestaurantView extends StatelessWidget {
  final RestaurantModel model;

  RestaurantView({
    Key key,
    @required this.model,
  })  : assert(model != null),
        super(key: key);

  String toDay(int weekday) {
    if (weekday == 1) return 'Lunedì';
    if (weekday == 2) return 'Martedì';
    if (weekday == 3) return 'Mercoledì';
    if (weekday == 4) return 'Giovedì';
    if (weekday == 5) return 'Venerdì';
    if (weekday == 6) return 'Sabato';
    return 'Domenica';
  }

  @override
  Widget build(BuildContext context) {
    String times = model.getTimetableString();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Image.network(
            model.imageUrl,
            fit: BoxFit.fitHeight,
          ),
          Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: TextStyle(fontSize: 20),
                      child: Text("${model.name}"),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.update,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            (times != null) ? Text(times) : Container(),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
