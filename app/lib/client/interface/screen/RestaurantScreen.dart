import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/client/model/CartModel.dart';
import 'package:resmedia_taporty_flutter/client/model/CartProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/InfoRestaurantPage.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/MenuPages.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

class RestaurantScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'RestaurantScreen';

  String get route => ROUTE;
  final RestaurantModel restaurantModel;
  final GeoPoint customerCoordinates;
  final String customerAddress;
  final String restaurantAddress;

  RestaurantScreen({Key key, @required this.restaurantModel, @required this.customerCoordinates, @required this.customerAddress, @required this.restaurantAddress}) : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final double iconSize = 32;

  @override
  void dispose() {
    RestaurantBloc.close();
    CartBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    List<CartProductModel> productCartList = List<CartProductModel>();
    final restaurantBloc = RestaurantBloc.init(restaurantId: widget.restaurantModel.id);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          centerTitle: true,
          title: Text(widget.restaurantModel.id),
          actions: <Widget>[
            StreamBuilder<CartModel>(
              stream: CartBloc.of().outCart,
              builder: (context, AsyncSnapshot<CartModel> cartSnapshot) {
                return StreamBuilder<User>(
                  stream: UserBloc.of().outUser,
                  builder: (context, userSnapshot) {
                    return StreamBuilder<List<ProductModel>>(
                        stream: restaurantBloc.outProducts,
                        builder: (context, AsyncSnapshot<List<ProductModel>> productListSnapshot) {
                          if (cartSnapshot.hasData && userSnapshot.hasData && productListSnapshot.hasData) {
                            productCartList.clear();
                            for (int i = 0; i < productListSnapshot.data.length; i++) {
                              var temp = productListSnapshot.data.elementAt(i);
                              var find = cartSnapshot.data.getProduct(temp.id, temp.restaurantId, userSnapshot.data.model.id);
                              if (find != null && find.quantity > 0) {
                                productCartList.add(find);
                              }
                            }

                            int count = cartSnapshot.data.getTotalItems(productCartList);
                            return Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  onPressed: _pushCheckoutScreen,
                                ),
                                Text(
                                  count.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Comfortaa',
                                  ),
                                )
                              ],
                            );
                          }
                          return Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: _pushCheckoutScreen,
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Comfortaa',
                                ),
                              )
                            ],
                          );
                        });
                  },
                );
              },
            ),
            /*IconButton(
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
              ),*/
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                EasyRouter.push(context, AccountScreen());
              },
            )
          ],
          bottom: TabBar(labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), tabs: [
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
        body: StreamBuilder<User>(
          stream: UserBloc.of().outUser,
          builder: (context, user) {
            if (!user.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return StreamBuilder<RestaurantModel>(
              stream: RestaurantBloc.init(restaurantId: widget.restaurantModel.id).outRestaurant,
              builder: (context, rest) {
                return StreamBuilder(
                    stream: Database().getUser(user.data.userFb),
                    builder: (context, model) {
                      if (user.hasData && rest.hasData && model.hasData) {
                        if (model.data.type != 'user' && model.data.type != null) {
                          return RaisedButton(
                            child: Text('Sei stato disabilitato clicca per fare logout'),
                            onPressed: () {
                              UserBloc.of().logout();
                              LoginHelper().signOut();
                              EasyRouter.pushAndRemoveAll(context, LoginScreen());
                            },
                          );
                          //EasyRouter.pushAndRemoveAll(context, LoginScreen());
                        }
                        if (rest.data.isDisabled != null && rest.data.isDisabled) {
                          return Padding(
                            child: Text('Ristorante non abilitato scegline un\'altro'),
                            padding: EdgeInsets.all(8.0),
                          );
                        }
                        return TabBarView(
                          children: <Widget>[
                            InfoRestaurantPage(model: widget.restaurantModel, address: widget.restaurantAddress),
                            FoodPage(model: widget.restaurantModel),
                            DrinkPage(model: widget.restaurantModel),
                          ],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    });
              },
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0 / 2, horizontal: 12.0 * 2),
            color: colorScheme.primary,
            child: SafeArea(
              top: false,
              right: false,
              left: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    color: theme.primaryColor,
                    child: Text('Vai al carrello'),
                    onPressed: _pushCheckoutScreen,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pushCheckoutScreen() {
    UserBloc.of().outUser.first.then((user) {
      EasyRouter.push(
        context,
        CheckoutScreen(
          restaurant: widget.restaurantModel,
          user: user.model,
          customerCoordinates: widget.customerCoordinates,
          customerAddress: widget.customerAddress,
        ),
      );
    });
  }
}
