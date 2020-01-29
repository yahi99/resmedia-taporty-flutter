import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierListBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/page/SupplierCategoryListPage.dart';
import 'package:resmedia_taporty_customer/interface/page/SupplierListPage.dart';
import 'package:resmedia_taporty_customer/interface/screen/SupplierScreen.dart';
import 'package:resmedia_taporty_customer/interface/widget/SearchBar.dart';

class SupplierListScreen extends StatefulWidget {
  SupplierListScreen({Key key}) : super(key: key);

  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final UserBloc userBloc = $Provider.of<UserBloc>();
  final SupplierListBloc _supplierListBloc = $Provider.of<SupplierListBloc>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_supplierListBloc.category != null) {
          _supplierListBloc.clear();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.public),
            onPressed: () {
              Navigator.pushNamed(context, "/geolocalization");
            },
          ),
          title: Text('Fornitori nella tua zona'),
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
            searchBarStream: _supplierListBloc.searchBarController,
          ),
        ),
        body: StreamBuilder<SupplierCategoryModel>(
          stream: _supplierListBloc.outCategory,
          builder: (context, AsyncSnapshot<SupplierCategoryModel> categorySnapshot) {
            if (categorySnapshot.data == null) return SupplierCategoryListPage();
            return SupplierListPage(categorySnapshot.data);
          },
        ),
      ),
    );
  }
}
