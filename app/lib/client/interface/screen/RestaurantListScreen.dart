import 'dart:async';
import 'dart:io';

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
import 'package:resmedia_taporty_flutter/drivers/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/GeolocalizationScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_taporty_flutter/common/interface/view/CardListView.dart';
import 'package:resmedia_taporty_flutter/client/interface/widget/SearchBar.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/mainRestaurant.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

class RestaurantListScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'RestaurantListScreen';

  String get route => ROUTE;
  final UserModel user;
  final Position position;
  final bool isAnonymous;

  RestaurantListScreen(
      {Key key,
      @required this.user,
      @required this.position,
      @required this.isAnonymous})
      : super(key: key);

  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final double iconSize = 32;

  BuildContext dialog;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  StreamController barStream;

  void showNotification(
      BuildContext context, Map<String, dynamic> message) async {
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
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    RestaurantsBloc.close();
    barStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    barStream = new StreamController<String>.broadcast();
    firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    dialog = context;
    final UserBloc userBloc = UserBloc.of();
    final RestaurantsBloc _restaurantsBloc = RestaurantsBloc.instance();
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
        backgroundColor: red,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              EasyRouter.push(context, AccountScreenDriver());
            },
          ),
        ],
        bottom: SearchBar(
          barStream: barStream,
        ),
      ),
      body: CacheStreamBuilder<List<RestaurantModel>>(
          stream: _restaurantsBloc.outRestaurants,
          builder: (context, snap) {
            return StreamBuilder<User>(
              stream: UserBloc.of().outUser,
              builder: (ctx, user) {
                if (!snap.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return StreamBuilder<String>(
                  stream: barStream.stream,
                  builder: (ctx, bar) {
                    return StreamBuilder(
                      stream: Database().getUser(user.data.userFb),
                      builder: (ctx, model) {
                        if (snap.hasData && user.hasData && model.hasData) {
                          if (model.data.type != 'user' &&
                              model.data.type != null) {
                            return RaisedButton(
                              child: Text(
                                  'Sei stato disabilitato clicca per fare logout'),
                              onPressed: () {
                                UserBloc.of().logout();
                                LoginHelper().signOut();
                                EasyRouter.pushAndRemoveAll(
                                    context, LoginScreen());
                              },
                            );
                          }
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CardListView(
                                children: snap.data.map<Widget>((_model) {
                                  //final distance=Distance();
                                  if (bar.hasData &&
                                      !_model.id
                                          .toLowerCase()
                                          .contains(bar.data.toLowerCase()))
                                    return Container();
                                  var stream;
                                  if (_model.getPos() != null &&
                                      widget.position != null) {
                                    final LatLng start = _model.getPos();
                                    final LatLng end = LatLng(
                                        widget.position.latitude,
                                        widget.position.longitude);
                                    stream = userBloc
                                        .getDistance(start, end)
                                        .asStream();
                                    // TODO: Rimuovere l'else che permette un comportamento scorretto.
                                  } else
                                    stream =
                                        userBloc.getMockDistance().asStream();
                                  return StreamBuilder<double>(
                                      stream: stream,
                                      builder: (ctx, snap) {
                                        if (!snap.hasData) return Container();
                                        // TODO: Ripristinare a tempo debito.
                                        // if(snap.data/1000<_model.km) {
                                        if (_model.isDisabled != null &&
                                            _model.isDisabled)
                                          return Container();
                                        return InkWell(
                                          onTap: () async {
                                            EasyRouter.push(
                                              context,
                                              RestaurantScreen(
                                                address: (await Geocoder.local
                                                        .findAddressesFromCoordinates(
                                                            new Coordinates(
                                                                widget.position
                                                                    .latitude,
                                                                widget.position
                                                                    .longitude)))
                                                    .first
                                                    .addressLine,
                                                position: widget.position,
                                                model: _model,
                                              ),
                                            );
                                          },
                                          child: RestaurantView(
                                            model: _model,
                                          ),
                                        );
                                      });
                                }).toList(),
                              ),
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
    //print(model.id);
    //if (!model.img.startsWith('assets')) downloadFile(model.img);
    String times;
    String day = toDay(DateTime.now().weekday);
    print(model.lunch.toString() + '\n' + model.dinner.toString());
    print(day);
    if (model.lunch == null && model.dinner == null)
      times = 'Chiuso';
    else if (model.lunch == null && model.dinner != null) {
      if (model.dinner.containsKey(day)) {
        times = model.dinner.remove(day);
      } else
        times = 'Chiuso';
    } else if (model.lunch != null && model.dinner == null) {
      if (model.lunch.containsKey(day)) {
        times = model.lunch.remove(day);
      } else
        times = 'Chiuso';
    } else if (model.lunch != null && model.dinner != null) {
      if (model.lunch.containsKey(day) && model.dinner.containsKey(day)) {
        times = model.lunch.remove(day) + '\n' + model.dinner.remove(day);
      } else if (model.lunch.containsKey(day) &&
          !model.dinner.containsKey(day)) {
        times = model.lunch.remove(day);
      } else if (!model.lunch.containsKey(day) &&
          model.dinner.containsKey(day)) {
        times = model.dinner.remove(day);
      } else
        times = 'Chiuso';
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          (model.img.startsWith('assets'))
              ? Image.asset(
                  model.img,
                  fit: BoxFit.fitHeight,
                )
              : Image.network(
                  model.img,
                  fit: BoxFit.fitHeight,
                ),
          Container(
            color: Colors.black,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: TextStyle(fontSize: 20),
                      child: Text("${model.id}"),
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
