import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/InfoRestaurantPage.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/MenuPages.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

class RestaurantScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'RestaurantScreen';

  String get route => ROUTE;
  static bool isOrdered = false;
  final RestaurantModel restaurantModel;
  final Position position;
  final String address;

  RestaurantScreen(
      {Key key,
      @required this.restaurantModel,
      @required this.position,
      @required this.address})
      : super(key: key);

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
    //_restaurantBloc.init(model: widget.model);
    //_cartBloc.load(outRestaurants: RestaurantBloc.of().outRestaurant);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    List<ProductCart> productCartList = List<ProductCart>();
    final restaurantBloc =
        RestaurantBloc.init(idRestaurant: widget.restaurantModel.id);
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: colorScheme.primary,
            centerTitle: true,
            title: Text(widget.restaurantModel.id),
            actions: <Widget>[
              StreamBuilder<Cart>(
                stream: CartBloc.of().outDrinksCart,
                builder: (context, drinkCartSnapshot) {
                  return StreamBuilder<Cart>(
                    stream: CartBloc.of().outFoodsCart,
                    builder: (context, foodCartSnapshot) {
                      return StreamBuilder<User>(
                        stream: UserBloc.of().outUser,
                        builder: (context, userSnapshot) {
                          return StreamBuilder<List<DrinkModel>>(
                              stream: restaurantBloc.outDrinks,
                              builder: (context, drinkListSnapshot) {
                                return StreamBuilder<List<FoodModel>>(
                                    stream: restaurantBloc.outFoods,
                                    builder: (context, foodListSnapshot) {
                                      if (drinkCartSnapshot.hasData &&
                                          foodCartSnapshot.hasData &&
                                          userSnapshot.hasData &&
                                          foodListSnapshot.hasData &&
                                          drinkListSnapshot.hasData) {
                                        //if(user.data.model.type!='user') EasyRouter.pushAndRemoveAll(context, LoginScreen());
                                        productCartList.clear();
                                        for (int i = 0;
                                            i < drinkListSnapshot.data.length;
                                            i++) {
                                          var temp = drinkListSnapshot.data
                                              .elementAt(i);
                                          var find = drinkCartSnapshot.data
                                              .getProduct(
                                                  temp.id,
                                                  temp.restaurantId,
                                                  userSnapshot.data.model.id);
                                          if (find != null &&
                                              find.countProducts > 0) {
                                            productCartList.add(find);
                                          }
                                        }
                                        for (int i = 0;
                                            i < foodListSnapshot.data.length;
                                            i++) {
                                          var temp = foodListSnapshot.data
                                              .elementAt(i);
                                          var find = foodCartSnapshot.data
                                              .getProduct(
                                                  temp.id,
                                                  temp.restaurantId,
                                                  userSnapshot.data.model.id);
                                          if (find != null &&
                                              find.countProducts > 0) {
                                            productCartList.add(find);
                                          }
                                        }
                                        //final state = MyInheritedWidget.of(context);
                                        int count = drinkCartSnapshot.data
                                            .getTotalItems(productCartList);
                                        return Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.shopping_cart),
                                              onPressed: () {
                                                UserBloc.of()
                                                    .outUser
                                                    .first
                                                    .then((user) {
                                                  Geocoder.local
                                                      .findAddressesFromCoordinates(
                                                          Coordinates(
                                                              widget.position
                                                                  .latitude,
                                                              widget.position
                                                                  .longitude))
                                                      .then((addresses) {
                                                    EasyRouter.push(
                                                        context,
                                                        CheckoutScreen(
                                                          model: widget
                                                              .restaurantModel,
                                                          user: user.model,
                                                          position:
                                                              widget.position,
                                                          description:
                                                              addresses.first,
                                                        ));
                                                  });
                                                });
                                              },
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
                                            onPressed: () {
                                              UserBloc.of()
                                                  .outUser
                                                  .first
                                                  .then((user) {
                                                Geocoder.local
                                                    .findAddressesFromCoordinates(
                                                        Coordinates(
                                                            widget.position
                                                                .latitude,
                                                            widget.position
                                                                .longitude))
                                                    .then((addresses) {
                                                  EasyRouter.push(
                                                      context,
                                                      CheckoutScreen(
                                                        model: widget
                                                            .restaurantModel,
                                                        user: user.model,
                                                        position:
                                                            widget.position,
                                                        description:
                                                            addresses.first,
                                                      ));
                                                });
                                              });
                                            },
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
                                      //here
                                    });
                              });
                        },
                      );
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
          body: StreamBuilder<User>(
            stream: UserBloc.of().outUser,
            builder: (context, user) {
              if (!user.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return StreamBuilder<RestaurantModel>(
                stream:
                    RestaurantBloc.init(idRestaurant: widget.restaurantModel.id)
                        .outRestaurant,
                builder: (context, rest) {
                  return StreamBuilder(
                      stream: Database().getUser(user.data.userFb),
                      builder: (context, model) {
                        if (user.hasData && rest.hasData && model.hasData) {
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
                            //EasyRouter.pushAndRemoveAll(context, LoginScreen());
                          }
                          if (rest.data.isDisabled != null &&
                              rest.data.isDisabled) {
                            return Padding(
                              child: Text(
                                  'Ristorante non abilitato scegline un\'altro'),
                              padding: EdgeInsets.all(8.0),
                            );
                          }
                          return TabBarView(
                            children: <Widget>[
                              InfoRestaurantPage(
                                  model: widget.restaurantModel,
                                  address: widget.address),
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
              padding: const EdgeInsets.symmetric(
                  vertical: SPACE / 2, horizontal: SPACE * 2),
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
                                  model: widget.restaurantModel,
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
              ),
            ),
          ),
        ));
  }
}
