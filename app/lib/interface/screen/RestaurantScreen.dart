import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_flutter/interface/page/InfoRestaurantPage.dart';
import 'package:resmedia_taporty_flutter/interface/page/MenuPages.dart';
import 'package:resmedia_taporty_flutter/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';

class RestaurantScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'RestaurantScreen';

  String get route => ROUTE;
  static bool isOrdered = false;
  final RestaurantModel model;
  final Position position;
  final String address;

  RestaurantScreen(
      {Key key,
      @required this.model,
      @required this.position,
      @required this.address})
      : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

/*class _RestaurantScreenState extends State<RestaurantScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prova'),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('restaurants')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Loading...');
                  default:
                    return ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Column(
                          children:<Widget>[
                            Text(document['id']),
                            Text(document['description']),
                          ],
                        );
                      }).toList(),
                    );
                }
              },
            )),
      ),
    );
  }

}*/

class _RestaurantScreenState extends State<RestaurantScreen> {
  final double iconSize = 32;

  final RestaurantBloc _restaurantBloc = RestaurantBloc.of();

  @override
  void dispose() {
    RestaurantBloc.close();
    //UserBloc.of().dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //_restaurantBloc.init(model: widget.model);
    //_cartBloc.load(outRestaurants: RestaurantBloc.of().outRestaurant);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: cls.primary,
            centerTitle: true,
            title: Text(widget.model.id),
            actions: <Widget>[
              StreamBuilder<Cart>(
                stream: CartBloc.of().outDrinksCart,
                builder: (ctx, drinks) {
                  return StreamBuilder<Cart>(
                    stream: CartBloc.of().outFoodsCart,
                    builder: (ctx, foods) {
                      return StreamBuilder<User>(
                        stream: UserBloc.of().outUser,
                        builder: (ctx, user) {
                          if (drinks.hasData && foods.hasData && user.hasData) {
                            int count = drinks.data.getTotalItems(
                                drinks.data.products,
                                user.data.userFb.uid,
                                widget.model.id);
                            return Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  onPressed: () {
                                    UserBloc.of().outUser.first.then((user) {
                                      Geocoder.local
                                          .findAddressesFromCoordinates(
                                              Coordinates(
                                                  widget.position.latitude,
                                                  widget.position.longitude))
                                          .then((addresses) {
                                        EasyRouter.push(
                                            context,
                                            CheckoutScreen(
                                              model: widget.model,
                                              user: user.model,
                                              position: widget.position,
                                              description: addresses.first,
                                            ));
                                      });
                                    });
                                  },
                                ),
                                Text(count.toString(),style: TextStyle(color: Colors.white),)
                              ],
                            );
                          }
                          return Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {
                                  UserBloc.of().outUser.first.then((user) {
                                    Geocoder.local
                                        .findAddressesFromCoordinates(
                                        Coordinates(
                                            widget.position.latitude,
                                            widget.position.longitude))
                                        .then((addresses) {
                                      EasyRouter.push(
                                          context,
                                          CheckoutScreen(
                                            model: widget.model,
                                            user: user.model,
                                            position: widget.position,
                                            description: addresses.first,
                                          ));
                                    });
                                  });
                                },
                              ),
                              Text('0',style: TextStyle(color: Colors.white),)
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  UserBloc.of().outUser.first.then((user) {
                    Geocoder.local
                        .findAddressesFromCoordinates(Coordinates(
                            widget.position.latitude,
                            widget.position.longitude))
                        .then((addresses) {
                      EasyRouter.push(
                          context,
                          CheckoutScreen(
                            model: widget.model,
                            user: user.model,
                            position: widget.position,
                            description: addresses.first,
                          ));
                    });
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  EasyRouter.push(context, AccountScreenDriver());
                },
              )
            ],
            bottom: TabBar(
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(
                    text: 'Chi siamo',
                  ),
                  Tab(
                    text: 'Menù',
                  ),
                  Tab(
                    text: 'Bibite',
                  )
                ]),
          ),
          body: TabBarView(
            children: <Widget>[
              InfoRestaurantPage(address: widget.address, model: widget.model),
              FoodsPage(model: widget.model),
              DrinksPage(model: widget.model),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: SPACE / 2, horizontal: SPACE * 2),
                color: cls.primary,
                child: SafeArea(
                  top: false,
                  right: false,
                  left: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FlatButton(
                            color: theme.primaryColor,
                            child: Text('Vai al carrello'),
                            onPressed: () {
                              UserBloc.of().outUser.first.then((user) {
                                Geocoder.local
                                    .findAddressesFromCoordinates(Coordinates(
                                        widget.position.latitude,
                                        widget.position.longitude))
                                    .then((addresses) {
                                  EasyRouter.push(
                                      context,
                                      CheckoutScreen(
                                        model: widget.model,
                                        user: user.model,
                                        position: widget.position,
                                        description: addresses.first,
                                      ));
                                });
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.history,
                              color: Colors.white,
                              size: iconSize,
                            ),
                          ),
                          Text(
                            '15 min c/a',
                            style: theme.textTheme.button,
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}
