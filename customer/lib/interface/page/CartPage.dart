import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_customer/interface/view/BottonButtonBar.dart';
import 'package:resmedia_taporty_customer/interface/view/ProductViewCart.dart';
import 'package:toast/toast.dart';

class CartPage extends StatefulWidget {
  final SupplierModel supplier;
  final TabController controller;

  CartPage({Key key, @required this.supplier, @required this.controller}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartPage> with AutomaticKeepAliveClientMixin {
  int count;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    count = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tt = Theme.of(context);
    final supplierBloc = SupplierBloc.init(supplierId: widget.supplier.id);
    final cartBloc = $Provider.of<CartBloc>();
    final user = $Provider.of<UserBloc>();
    List<CartProductModel> cartCounter = List<CartProductModel>();
    return StreamBuilder<FirebaseUser>(
      stream: user.outFirebaseUser,
      builder: (context, uid) {
        return StreamBuilder<CartModel>(
            stream: cartBloc.cartController.outCart,
            builder: (context, cartSnapshot) {
              if (!cartSnapshot.hasData || !uid.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Scaffold(
                  body: StreamBuilder<List<ProductModel>>(
                    stream: supplierBloc.outProducts,
                    builder: (context, AsyncSnapshot<List<ProductModel>> productSnapshot) {
                      if (!productSnapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      cartCounter.clear();
                      for (int i = 0; i < productSnapshot.data.length; i++) {
                        var temp = productSnapshot.data.elementAt(i);
                        var find = cartSnapshot.data.getProduct(temp.id, temp.supplierId, uid.data.uid);
                        if (find != null && find.quantity > 0) {
                          cartCounter.add(find);
                        }
                      }
                      final state = CheckoutScreenInheritedWidget.of(context);
                      state.productCount = cartSnapshot.data.getTotalItems(cartCounter);
                      return ProductsFoodDrinkBuilder(
                        products: productSnapshot.data,
                        id: widget.supplier.id,
                      );
                    },
                  ),
                  bottomNavigationBar: BottomButtonBar(
                    color: tt.primaryColor,
                    child: FlatButton(
                      child: Text(
                        "Continua",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: tt.primaryColor,
                      onPressed: () {
                        final state = CheckoutScreenInheritedWidget.of(context);
                        if (state.productCount > 0)
                          widget.controller.animateTo(widget.controller.index + 1);
                        else
                          Toast.show('Non hai elementi nel carrello!', context, duration: 3);
                      },
                    ),
                  ));
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProductsFoodDrinkBuilder extends StatelessWidget {
  final List<ProductModel> products;
  final CartBloc cartBloc = $Provider.of<CartBloc>();
  final String id;

  ProductsFoodDrinkBuilder({Key key, @required this.products, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List<Widget>();
    List<CartProductModel> prod = List<CartProductModel>();
    final UserBloc user = $Provider.of<UserBloc>();
    return StreamBuilder<CartModel>(
      stream: cartBloc.cartController.outCart,
      builder: (_, cartSnapshot) {
        return StreamBuilder<FirebaseUser>(
          stream: user.outFirebaseUser,
          builder: (context, userSnapshot) {
            if (userSnapshot.hasData && cartSnapshot.hasData) {
              list.clear();
              prod.clear();
              for (int i = 0; i < products.length; i++) {
                var temp = products.elementAt(i);
                var find = cartSnapshot.data.getProduct(temp.id, temp.supplierId, userSnapshot.data.uid);
                if (find != null && find.quantity > 0) {
                  prod.add(find);
                  list.add(ProductViewCart(
                    model: temp,
                    cartController: cartBloc.cartController,
                  ));
                }
              }
              CartModel cart = CartModel(products: prod);
              list.add(
                Container(
                  color: Colors.white10,
                  child: Center(
                    child: Text(
                      'Prezzo totale: ' + (cart.getTotalPrice(cart.products, userSnapshot.data.uid, id).toStringAsFixed(2)) + "€",
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
          },
        );
      },
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DefaultTextStyle(
                style: theme.textTheme.subtitle,
                child: Text((products.length == 0) ? 'Non ci sono elementi nel Carrello' : 'Carrello'),
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