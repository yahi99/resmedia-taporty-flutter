import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/CheckoutBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/page/InfoSupplierPage.dart';
import 'package:resmedia_taporty_customer/interface/page/ProductCategoryListPage.dart';
import 'package:resmedia_taporty_customer/interface/page/ProductListPage.dart';

class SupplierScreen extends StatefulWidget {
  SupplierScreen({Key key}) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final supplierBloc = $Provider.of<SupplierBloc>();
  final cartBloc = $Provider.of<CartBloc>();

  @override
  void dispose() {
    supplierBloc.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          title: StreamBuilder<SupplierModel>(
            stream: supplierBloc.outSupplier,
            builder: (_, supplierSnap) => Text(
              supplierSnap.data?.name ?? "Caricamento...",
              style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
            ),
          ),
          actions: <Widget>[
            StreamBuilder<CartModel>(
              stream: cartBloc.outCart,
              builder: (context, AsyncSnapshot<CartModel> cartSnapshot) {
                return StreamBuilder<UserModel>(
                  stream: $Provider.of<UserBloc>().outUser,
                  builder: (context, userSnapshot) {
                    if (cartSnapshot.hasData && userSnapshot.hasData) {
                      int count = cartSnapshot.data.totalItems;
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
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, "/account");
              },
            )
          ],
          bottom: TabBar(
            labelStyle: theme.textTheme.body1.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                text: 'Chi siamo',
              ),
              Tab(
                text: 'Prodotti',
              ),
            ],
          ),
        ),
        body: StreamBuilder<SupplierModel>(
          stream: supplierBloc.outSupplier,
          builder: (context, supplierSnapshot) {
            if (supplierSnapshot.hasData) {
              var supplier = supplierSnapshot.data;
              return TabBarView(
                children: <Widget>[
                  InfoSupplierPage(supplier: supplier),
                  StreamBuilder<bool>(
                      stream: supplierBloc.outIsSelectingCategories,
                      builder: (context, isSelectingCategories) {
                        var isSelecting = isSelectingCategories.data ?? false;
                        if (isSelecting) return ProductCategoryListPage();
                        return ProductListPage();
                      }),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
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
    $Provider.of<CheckoutBloc>().setDefaultValues();
    Navigator.pushNamed(
      context,
      "/checkout",
    );
  }
}
