import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:mobile_app/interface/screen/RestaurantScreen.dart';
import 'package:mobile_app/interface/view/BottonButtonBar.dart';
import 'package:mobile_app/interface/view/ProductView.dart';
import 'package:mobile_app/interface/view/ProductViewCart.dart';
import 'package:mobile_app/logic/bloc/CartBloc.dart';
import 'package:mobile_app/logic/bloc/RestaurantBloc.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/model/ProductModel.dart';
import 'package:mobile_app/model/RestaurantModel.dart';
import 'package:rxdart/rxdart.dart';

class CartPage extends StatefulWidget {
  final RestaurantModel model;

  CartPage({Key key, @required this.model}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    final tt=Theme.of(context);
    final restaurantBloc = RestaurantBloc.init(idRestaurant: widget.model.id);
    final cartBloc = CartBloc.of();
    final user=UserBloc.of();
    return StreamBuilder<FirebaseUser>(
        stream: user.outFirebaseUser,
        builder: (context, uid)
    {
      return StreamBuilder<Cart>(
        stream: cartBloc.drinksCartController.outCart,
        builder: (context, sp1) {
          return StreamBuilder<Cart>(
            stream: cartBloc.foodsCartController.outCart,
            builder: (context, sp2) {
              if (!sp1.hasData || !sp2.hasData || !uid.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Scaffold(
                  body: StreamBuilder<List<DrinkModel>>(
                    stream: restaurantBloc.outDrinks,
                    builder: (context, snapshot) {
                      return StreamBuilder<List<FoodModel>>(
                        stream: restaurantBloc.outFoods,
                        builder: (context, snap) {
                          if (!snapshot.hasData || !snap.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          return ProductsFoodDrinkBuilder(
                            drinks: snapshot.data,
                            foods: snap.data,
                            id: widget.model.id,
                          );
                        },
                      );
                    },
                  ),
                  bottomNavigationBar: BottomButtonBar(
                    color: tt.primaryColor,
                    child:FlatButton(
                          child: Text(
                            "Continua",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: tt.primaryColor,
                          onPressed: () {
                            DefaultTabController
                                .of(context)
                                .index += 1;
                          },
                        ),
                  ));
            },
          );
        },
      );
    },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ProductsFoodDrinkBuilder extends StatelessWidget {
  final List<FoodModel> foods;
  final List<DrinkModel> drinks;
  final CartBloc cartBloc = CartBloc.of();
  final String id;

  ProductsFoodDrinkBuilder(
      {Key key, @required this.foods, @required this.drinks,@required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List<Widget>();
    List<ProductCart> prod=List<ProductCart>();
    final UserBloc user = UserBloc.of();
    final update=RestaurantScreen.isOrdered;
    RestaurantScreen.isOrdered=false;
    return StreamBuilder<Cart>(
        stream: cartBloc.foodsCartController.outCart,
        builder: (_, snapshot) {
          return StreamBuilder<Cart>(
              stream: cartBloc.drinksCartController.outCart,
              builder: (_, sp) {
                return StreamBuilder<FirebaseUser>(
                    stream: user.outFirebaseUser,
                    builder: (context, snap) {

                      if (snap.hasData && snapshot.hasData && sp.hasData) {
                        list.clear();
                        prod.clear();
                        for (int i = 0; i < drinks.length; i++) {
                          var temp = drinks.elementAt(i);
                          var find = sp.data.getProduct(
                              temp.id, temp.restaurantId, snap.data.uid);
                          if (find != null && find.countProducts > 0) {
                            prod.add(find);
                            list.add(ProductViewCart(
                              update:update,
                              model: temp,
                              cartController: cartBloc.drinksCartController,
                            ));
                          }
                        }
                        for (int i = 0; i < foods.length; i++) {
                          var temp = foods.elementAt(i);
                          var find = snapshot.data.getProduct(
                              temp.id, temp.restaurantId, snap.data.uid);
                          if (find != null && find.countProducts > 0) {
                            prod.add(find);
                            list.add(ProductViewCart(
                              update:update,
                              model: temp,
                              cartController: cartBloc.foodsCartController,
                            ));
                          }
                        }
                        Cart carrello=new Cart(products: prod);
                        list.add(
                          new Container(
                            color: Colors.white10,
                            child:Center(
                                child: new Text('Prezzo totale: '+(carrello.getTotalPrice(carrello.products,snap.data.uid,id).toString()),

                                ),
                            ),
                        ),
                        );
                        return GroupsVoid(
                          products: list,
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    });
              });
        });
  }
}

class GroupsVoid extends StatelessWidget {
  final List<Widget> products;

  GroupsVoid({
    Key key,
    @required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverStickyHeader(
          header: Container(
            color: Colors.black12,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DefaultTextStyle(
                style: theme.textTheme.subtitle,
                child: Text((products.length == 0)
                    ? 'Non ci sono elementi nel Carrello'
                    : 'Carrello'),
              ),
            ),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: products[index],
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }
}
