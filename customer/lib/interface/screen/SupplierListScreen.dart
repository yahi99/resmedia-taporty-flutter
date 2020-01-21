import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/screen/SupplierScreen.dart';
import 'package:resmedia_taporty_customer/interface/widget/SearchBar.dart';

class SupplierListScreen extends StatefulWidget {
  final UserModel user;
  final GeoPoint customerCoordinates;
  final String customerAddress;
  final bool isAnonymous;

  SupplierListScreen({Key key, @required this.user, @required this.customerCoordinates, @required this.customerAddress, @required this.isAnonymous}) : super(key: key);

  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final double iconSize = 32;

  BuildContext dialog;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  StreamController searchBarStream;

  final UserBloc userBloc = $Provider.of<UserBloc>();
  final SuppliersBloc _suppliersBloc = SuppliersBloc.instance();

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
    $Provider.dispose<SuppliersBloc>();
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
            Navigator.pushNamed(context, "/geolocalization");
          },
        ),
        title: Text('Ristoranti nella tua zona'),
        backgroundColor: ColorTheme.RED,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, "/account");
            },
          ),
        ],
        bottom: SearchBar(
          searchBarStream: searchBarStream,
        ),
      ),
      body: CacheStreamBuilder<List<SupplierModel>>(
          stream: _suppliersBloc.outSuppliers,
          builder: (context, AsyncSnapshot<List<SupplierModel>> supplierListSnapshot) {
            return StreamBuilder<User>(
              stream: $Provider.of<UserBloc>().outUser,
              builder: (context, userSnapshot) {
                if (!supplierListSnapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return StreamBuilder<String>(
                  stream: searchBarStream.stream,
                  builder: (context, searchBarSnapshot) {
                    return StreamBuilder(
                      stream: Database().getUser(userSnapshot.data.userFb),
                      builder: (context, userModelSnapshot) {
                        if (supplierListSnapshot.hasData && userSnapshot.hasData && userModelSnapshot.hasData) {
                          if (userModelSnapshot.data.type != 'user' && userModelSnapshot.data.type != null) {
                            return RaisedButton(
                              child: Text('Sei stato disabilitato clicca per fare logout'),
                              onPressed: () {
                                $Provider.of<UserBloc>().logout();
                                LoginHelper().signOut();
                                Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                              },
                            );
                          }

                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: _buildSupplierListView(supplierListSnapshot.data, searchBarSnapshot),
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

  _buildSupplierListView(var supplierList, var searchBarSnapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: supplierList.length,
      itemBuilder: (context, int index) {
        //final distance=Distance();
        if (searchBarSnapshot.hasData && !supplierList[index].id.toLowerCase().contains(searchBarSnapshot.data.toLowerCase())) return Container();
        var stream;
        if (supplierList[index].getPos() != null && widget.customerCoordinates != null) {
          final LatLng start = supplierList[index].getPos();
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
              // if(snap.data/1000<supplierList[index].km) {
              if (supplierList[index].isDisabled != null && supplierList[index].isDisabled) return Container();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupplierScreen(
                          customerCoordinates: widget.customerCoordinates,
                          customerAddress: widget.customerAddress,
                          supplier: supplierList[index],
                        ),
                      ),
                    );
                  },
                  child: SupplierView(
                    model: supplierList[index],
                  ),
                ),
              );
            });
      },
    );
  }
}

class SupplierView extends StatelessWidget {
  final SupplierModel model;

  SupplierView({
    Key key,
    @required this.model,
  })  : assert(model != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String times = model.getTimetableString();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: model.imageUrl,
            fit: BoxFit.fitHeight,
            placeholder: (context, url) => SizedBox(
              height: 30.0,
              width: 30.0,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.grey)),
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
