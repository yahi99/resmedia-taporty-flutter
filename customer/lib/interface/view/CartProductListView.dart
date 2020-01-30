import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/interface/view/ProductView.dart';

class CartProductListView extends StatelessWidget {
  final CartModel cart;

  CartProductListView({Key key, @required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>();

    for (int i = 0; i < cart.supplierProducts.length; i++) {
      widgets.add(ProductView(cart.supplierProducts[i]));
    }
    widgets.add(
      Container(
        color: Colors.white10,
        child: Center(
          child: Text(
            'Prezzo totale: ' + (cart.totalPrice.toStringAsFixed(2)) + "€",
          ),
        ),
      ),
    );
    return GroupsVoid(
      widgets: widgets,
    );
  }
}

class GroupsVoid extends StatelessWidget {
  final List<Widget> widgets;

  GroupsVoid({
    Key key,
    @required this.widgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: Trasforma in una ListView
    return CustomScrollView(
      slivers: <Widget>[
        SliverStickyHeader(
          header: Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DefaultTextStyle(
                style: theme.textTheme.subtitle,
                child: Text((widgets.length == 0) ? 'Non ci sono elementi nel Carrello' : 'Carrello'),
              ),
            ),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: widgets[index],
                );
              },
              childCount: widgets.length,
            ),
          ),
        ),
      ],
    );
  }
}
