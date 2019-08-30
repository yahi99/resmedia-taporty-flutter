import 'package:easy_blocs/easy_blocs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:mobile_app/interface/page/CartPage.dart';
import 'package:mobile_app/interface/view/CardListView.dart';
import 'package:mobile_app/interface/view/TypeOrderView.dart';
import 'package:mobile_app/interface/widget/SearchBar.dart';
import 'package:mobile_app/logic/bloc/CartBloc.dart';
import 'package:mobile_app/logic/bloc/OrdersBloc.dart';
import 'package:mobile_app/logic/bloc/RestaurantBloc.dart';
import 'package:mobile_app/logic/bloc/TypesRestaurantsBloc.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/interface/view/type_restaurant.dart';
import 'package:mobile_app/model/OrderModel.dart';
import 'package:mobile_app/model/ProductModel.dart';
import 'package:mobile_app/model/TypesRestaurantModel.dart';
import 'package:easy_route/easy_route.dart';
import 'package:mobile_app/restaurant/view/ProductViewRestaurant.dart';

class MenuPage extends StatefulWidget implements WidgetRoute {
  final foods, drinks;

  static const ROUTE = "OrderListScreen";
  @override
  String get route => MenuPage.ROUTE;

  MenuPage({@required this.foods, @required this.drinks});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static const double SPACE_CELL = 8.0;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    OrdersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductsFoodDrinkBuilder(
        drinks: widget.drinks,
        foods: widget.foods,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ProductsFoodDrinkBuilder extends StatelessWidget {
  final List<FoodModel> foods;
  final List<DrinkModel> drinks;

  ProductsFoodDrinkBuilder(
      {Key key, @required this.foods, @required this.drinks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List<Widget>();
    list.clear();
    for (int i = 0; i < drinks.length; i++) {
      var temp = drinks.elementAt(i);
      list.add(ProductViewRestaurant(
        model: temp,
      ));
    }
    for (int i = 0; i < foods.length; i++) {
      var temp = foods.elementAt(i);
      list.add(ProductViewRestaurant(
        model: temp,
      ));
    }
    return GroupsVoid(
      products: list,
    );
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
                    ? 'Non ci sono elementi nel listino'
                    : 'Listino'),
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
