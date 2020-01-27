import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/ProductView.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class FoodPage extends StatelessWidget {
  final SupplierModel supplier;

  FoodPage({Key key, @required this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supplierBloc = $Provider.of<SupplierBloc>();
    return StreamBuilder<Map<ProductCategory, List<ProductModel>>>(
      stream: supplierBloc.outFoodsByCategory,
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
  final SupplierModel supplier;

  DrinkPage({Key key, @required this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supplierBloc = $Provider.of<SupplierBloc>();

    return StreamBuilder<Map<ProductCategory, List<ProductModel>>>(
      stream: supplierBloc.outDrinksByCategory,
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
  final CartBloc cartBloc = $Provider.of<CartBloc>();

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
                          product: product,
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
    return SingleChildScrollView(
      child: Column(
        children: children.keys.map<Widget>((group) {
          final products = children[group];
          return StickyHeader(
            header: Container(
              width: double.infinity,
              color: ColorTheme.LIGHT_GREY,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DefaultTextStyle(
                  style: theme.textTheme.subtitle,
                  child: group,
                ),
              ),
            ),
            content: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (_, index) => Padding(
                padding: EdgeInsets.all(16.0),
                child: products[index],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
