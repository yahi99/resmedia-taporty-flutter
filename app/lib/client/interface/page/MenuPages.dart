import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/ProductView.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';

class FoodsPage extends StatelessWidget {
  final RestaurantModel model;

  FoodsPage({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantBloc = RestaurantBloc.init(idRestaurant: model.id);
    return StreamBuilder<Map<FoodCategory, List<FoodModel>>>(
      stream: restaurantBloc.outCategorizedFoods,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return ProductsFoodBuilder(foods: snapshot.data);
      },
    );
  }
}

class DrinksPage extends StatelessWidget {
  final RestaurantModel model;

  DrinksPage({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantBloc = RestaurantBloc.init(idRestaurant: model.id);

    return StreamBuilder<Map<DrinkCategory, List<DrinkModel>>>(
      stream: restaurantBloc.outCategorizedDrinks,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return ProductsDrinkBuilder(
          drinks: snapshot.data,
        );
      },
    );
  }
}

class ProductsDrinkBuilder extends StatelessWidget {
  final Map<DrinkCategory, List<DrinkModel>> drinks;
  final CartBloc cartBloc = CartBloc.of();

  ProductsDrinkBuilder({Key key, @required this.drinks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupsVoid(
      children: drinks.map<Widget, List<Widget>>((nameGroup, products) {
        return MapEntry(
          Text(translateDrinkCategory(nameGroup)),
          products
              .map((product) => ProductView(
                    update: null,
                    model: product,
                    cartController: cartBloc.drinksCartController,
                    category: 'drinks',
                  ))
              .toList(),
        );
      }),
    );
  }
}

class ProductsFoodBuilder extends StatelessWidget {
  final Map<FoodCategory, List<FoodModel>> foods;
  final CartBloc cartBloc = CartBloc.of();

  ProductsFoodBuilder({Key key, @required this.foods}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupsVoid(
      children: foods.map<Widget, List<Widget>>((nameGroup, products) {
        return MapEntry(
          Text(translateFoodCategory(nameGroup)),
          products
              .map((product) => ProductView(
                    update: null,
                    model: product,
                    cartController: cartBloc.foodsCartController,
                    category: 'foods',
                  ))
              .toList(),
        );
      }),
    );
  }
}

class GroupsVoid extends StatelessWidget {
  final Map<Widget, List<Widget>> children;

  GroupsVoid({
    Key key,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: children.keys.map<Widget>((group) {
        final products = children[group];
        return SliverStickyHeader(
          overlapsContent: true,
          header: Container(
            color: Colors.grey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DefaultTextStyle(
                style: theme.textTheme.subtitle,
                child: group,
              ),
            ),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if(index==0) return Padding(
                  padding: EdgeInsets.only(top:42.0,bottom: 16.0,left: 16.0,right: 16.0),
                  child: products[index],
                );
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: products[index],
                );
              },
              childCount: products.length,
            ),
          ),
        );
      }).toList(),
    );
  }
}
