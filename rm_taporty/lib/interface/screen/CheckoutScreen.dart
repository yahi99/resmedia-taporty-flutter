import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/drivers/interface/screen/AccountScreen.dart';
import 'package:mobile_app/interface/page/CartPage.dart';
import 'package:mobile_app/interface/page/ConfirmPage.dart';
import 'package:mobile_app/interface/page/ShippingPage.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/interface/page/PaymentPage.dart';
import 'package:easy_route/easy_route.dart';
import 'package:mobile_app/model/RestaurantModel.dart';
import 'package:mobile_app/model/UserModel.dart';

class CheckoutScreen extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ProductsScreen";
  String get route => CheckoutScreen.ROUTE;
  final RestaurantModel model;
  final UserModel user;
  final Position position;
  final Address description;

  CheckoutScreen({Key key,@required this.model,@required this.user,
  @required this.position,@required this.description}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Paga'),
          backgroundColor: red,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                EasyRouter.push(context, AccountScreenDriver());
              },
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart, ),),
              Tab(icon: Icon(Icons.location_on,)),
              Tab(icon: Icon(Icons.credit_card, )),
              Tab(icon: Icon(Icons.flag, )),
            ],
          ),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border:  const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 4.0),
                borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
              ),
            ),
          ),
          child: MyInheritedWidget(child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              CartPage(model: widget.model),
              ShippingPage(user: widget.user,address: widget.description,),
              PaymentPage(),
              ConfirmPage(model: widget.model),
            ],
          ),),
        ),
      ),
    );
  }
}

class MyInheritedWidget extends InheritedWidget{

  final MyInheritedWidgetData data;

  MyInheritedWidget({Key key, @required Widget child}):assert(child!=null),data=MyInheritedWidgetData(),
  super(key:key,child:child);

  static MyInheritedWidgetData of(BuildContext context) =>(context.inheritFromWidgetOfExactType(MyInheritedWidget) as MyInheritedWidget).data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

}

class MyInheritedWidgetData{

  var name,cap,email,phone,address;

  //final StreamController _streamController =StreamController.broadcast();

  //Stream get stream => _streamController.stream;

  //Sink get sink => _streamController.sink;
}

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class ShoppingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

