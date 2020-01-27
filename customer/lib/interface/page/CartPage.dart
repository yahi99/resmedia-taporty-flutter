import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/BottonButtonBar.dart';
import 'package:resmedia_taporty_customer/interface/view/CartProductListView.dart';
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
    final cartBloc = $Provider.of<CartBloc>();

    return StreamBuilder<CartModel>(
      stream: cartBloc.outCart,
      builder: (context, cartSnapshot) {
        if (!cartSnapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return Scaffold(
          body: CartProductListView(
            cart: cartSnapshot.data,
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
                if (cartSnapshot.data.totalItems > 0)
                  widget.controller.animateTo(widget.controller.index + 1);
                else
                  Toast.show('Non hai elementi nel carrello!', context, duration: 3);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
