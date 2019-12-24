import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_taporty_flutter/control/interface/view/ProductViewCtrl.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';

class MenuCtrlPage extends StatefulWidget implements WidgetRoute {
  final foods, drinks;

  static const ROUTE = "MenuPage";

  @override
  String get route => MenuCtrlPage.ROUTE;

  MenuCtrlPage({@required this.foods, @required this.drinks});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuCtrlPage> {

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
    return Scaffold(
      body: ProductsFoodDrinkBuilder(
        drinks: widget.drinks,
        foods: widget.foods,
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
      list.add(ProductViewCtrl(
        model: temp,
      ));
    }
    for (int i = 0; i < foods.length; i++) {
      var temp = foods.elementAt(i);
      list.add(ProductViewCtrl(
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
            color: Colors.grey,
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
