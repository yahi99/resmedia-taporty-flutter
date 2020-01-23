import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/page/InfoSupplierPage.dart';
import 'package:resmedia_taporty_customer/interface/page/MenuPages.dart';
import 'package:resmedia_taporty_customer/interface/screen/CheckoutScreen.dart';

class SupplierScreen extends StatefulWidget {
  final SupplierModel supplier;
  final GeoPoint customerCoordinates;
  final String customerAddress;

  SupplierScreen({Key key, @required this.supplier, @required this.customerCoordinates, @required this.customerAddress}) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final double iconSize = 32;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    List<CartProductModel> productCartList = List<CartProductModel>();
    final supplierBloc = SupplierBloc.init(supplierId: widget.supplier.id);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          centerTitle: true,
          title: Text(widget.supplier.id),
          actions: <Widget>[
            StreamBuilder<CartModel>(
              stream: $Provider.of<CartBloc>().outCart,
              builder: (context, AsyncSnapshot<CartModel> cartSnapshot) {
                return StreamBuilder<UserModel>(
                  stream: $Provider.of<UserBloc>().outUser,
                  builder: (context, userSnapshot) {
                    return StreamBuilder<List<ProductModel>>(
                        stream: supplierBloc.outProducts,
                        builder: (context, AsyncSnapshot<List<ProductModel>> productListSnapshot) {
                          if (cartSnapshot.hasData && userSnapshot.hasData && productListSnapshot.hasData) {
                            productCartList.clear();
                            var user = userSnapshot.data;
                            for (int i = 0; i < productListSnapshot.data.length; i++) {
                              var temp = productListSnapshot.data.elementAt(i);
                              var find = cartSnapshot.data.getProduct(temp.id, temp.supplierId, user.id);
                              if (find != null && find.quantity > 0) {
                                productCartList.add(find);
                              }
                            }

                            int count = cartSnapshot.data.getTotalItems(productCartList);
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
                        });
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
          bottom: TabBar(labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), tabs: [
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
        body: StreamBuilder<UserModel>(
          stream: $Provider.of<UserBloc>().outUser,
          builder: (context, user) {
            if (!user.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return StreamBuilder<SupplierModel>(
              stream: SupplierBloc.init(supplierId: widget.supplier.id).outSupplier,
              builder: (context, supplierSnapshot) {
                if (user.hasData && supplierSnapshot.hasData) {
                  // TODO: Rivedi la disabilitazione dei fornitori
                  if (supplierSnapshot.data.isDisabled != null && supplierSnapshot.data.isDisabled) {
                    return Padding(
                      child: Text('Fornitore non abilitato scegline un\'altro'),
                      padding: EdgeInsets.all(8.0),
                    );
                  }
                  return TabBarView(
                    children: <Widget>[
                      InfoSupplierPage(model: widget.supplier, address: widget.supplier.address),
                      FoodPage(model: widget.supplier),
                      DrinkPage(model: widget.supplier),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
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
    $Provider.of<UserBloc>().outUser.first.then((user) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            supplier: widget.supplier,
            user: user,
            customerCoordinates: widget.customerCoordinates,
            customerAddress: widget.customerAddress,
          ),
        ),
      );
    });
  }
}
