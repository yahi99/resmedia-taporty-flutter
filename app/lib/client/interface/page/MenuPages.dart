import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/ProductView.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';

class FoodPage extends StatelessWidget {
  final RestaurantModel model;

  FoodPage({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantBloc = RestaurantBloc.init(restaurantId: model.id);
    return StreamBuilder<Map<ProductCategory, List<ProductModel>>>(
      stream: restaurantBloc.outFoodsByCategory,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return ProductsBuilder(products: snapshot.data);
      },
    );
  }
}

class DrinkPage extends StatelessWidget {
  final RestaurantModel model;

  DrinkPage({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantBloc = RestaurantBloc.init(restaurantId: model.id);

    return StreamBuilder<Map<ProductCategory, List<ProductModel>>>(
      stream: restaurantBloc.outDrinksByCategory,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return ProductsBuilder(
          products: snapshot.data,
        );
      },
    );
  }
}

class ProductsBuilder extends StatelessWidget {
  final Map<ProductCategory, List<ProductModel>> products;
  final CartBloc cartBloc = CartBloc.of();

  ProductsBuilder({Key key, @required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (products.isNotEmpty)
        ? GroupsVoid(
            children: products.map<Widget, List<Widget>>((nameGroup, products) {
              return MapEntry(
                Text(translateProductCategory(nameGroup)),
                products
                    .map((product) => ProductView(
                          model: product,
                          cartController: cartBloc.cartController,
                        ))
                    .toList(),
              );
            }),
          )
        : Padding(
            child: Text(
              'Non ci sono prodotti',
              style: Theme.of(context).textTheme.subtitle,
            ),
            padding: EdgeInsets.all(16.0),
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
            color: ColorTheme.LIGHT_GREY,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DefaultTextStyle(
                style: theme.textTheme.subtitle,
                child: group,
              ),
            ),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0)
                  return Padding(
                    padding: EdgeInsets.only(top: 42.0, bottom: 16.0, left: 16.0, right: 16.0),
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
