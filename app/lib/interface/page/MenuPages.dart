import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_taporty_flutter/interface/view/ProductView.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';

/*List<ProductModel> products = [
  FoodModel(img: 'assets/img/food/onionrings.JPG', title: 'Onion rings', price: '4,90'),
  FoodModel(img: 'assets/img/food/Chips.JPG', title: 'Chicken nuggets', price: '5,80'),
  FoodModel(img: 'assets/img/food/chicken.JPG', title: 'Pollo arrosto', price: '5,80'),
];


Map<String, List<ProductModel>> foods = {
  'ANTIPASTI': [
    FoodModel(img: 'assets/img/food/onionrings.JPG', title: 'Onion rings', price: '4,90'),
        DrinkModel(img: 'assets/img/drink/waterbottle.jpg', title: 'Acqua gassata 1lt', price: '1,50'),
  ],

  'PRIMI PIATTI': [
    FoodModel(img: 'assets/img/food/pastaragu.png', title: 'Pasta al ragù', price: '7,20'),
  ],
  'SECONDI PIATTI':[
    FoodModel(img: 'assets/img/food/chicken.JPG', title: 'Pollo arrosto', price: '5,80'),
  ],
  'DESSERT':[
    FoodModel(img: 'assets/img/food/tiramisù.png', title: 'Tiramisù', price: '5,00'),
  ],
};*/

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
/*Map<String, List<ProductModel>> _drinks = {
  'BIBITE': [
    DrinkModel(img: 'assets/img/drink/waterbottle.jpg', title: 'Acqua gassata 1lt', price: '1,50'),
    DrinkModel(img: 'assets/img/drink/coke.jpg', title: 'Coca Cola 300 ml', price: '2,50'),
  ],
  'VINI E BIRRE' :[
    DrinkModel(img: 'assets/img/drink/redwine.jpg', title: 'Vino Rosso', price: '4,50'),
  ],
  'DOPO PASTO':[
    DrinkModel(img: 'assets/img/drink/caffè.jpg', title: 'Caffè espresso', price: '1,50'),
  ]
};*/

/*class DrinksPage extends StatelessWidget {
  final restaurantBloc=RestaurantBloc.of();
  @override
  Widget build(BuildContext context) {
    return CacheStreamBuilder<RestaurantModel>(
      stream: restaurantBloc.outRestaurant,
      builder: (context, snap) {
        return ProductsBuilder(products: _drinks,);
      },
    );
  }
}*/

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

    //ProductsBuilder(products: _drinks,);
  }
}

/*
StreamBuilder<Map<DrinkCategory, List<DrinkModel>>>(
              stream: restaurantBloc.outCategorizedDrinks,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(),);

                return CustomScrollView(
                  slivers: [
                    ...snapshot.data.keys.map((category) {
                      final models = snapshot.data[category];

                      return Menu(
                        title: translateDrinkCategory(category),
                        childrenDelegate: SliverChildBuilderDelegate((_, index) {
                          final model = models[index];

                          return InkWell(
                            onTap: () => EasyRouter.push(context, DrinkScreen(
                              path: model.path,
                            )),
                            child: ProductCard(
                              model: model,
                            ),
                          );
                        },
                          childCount: models.length,
                        ),
                      );
                    }),
                    SliverBottomMenu(
                      left: backToRestaurant,
                      right: RaisedButton(
                        onPressed: () => EasyRouter.pop(context),
                        child: FittedText("Ordina"),
                      ),
                    ),
                  ],
                );
              },
            ),
 */

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
          header: Container(
            color: Colors.black12,
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
