import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/CheckoutBloc.dart';
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
  final cartBloc = $Provider.of<CartBloc>();
  final checkoutBloc = $Provider.of<CheckoutBloc>();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return StreamBuilder<CartModel>(
      stream: cartBloc.outCart,
      builder: (context, cartSnapshot) {
        if (!cartSnapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CartProductListView(
                  cart: cartSnapshot.data,
                ),
                Column(
                  children: [
                    HeaderWidget("Note aggiuntive"),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16, left: 16, right: 16),
                      child: TextFormField(
                        maxLines: null,
                        minLines: 4,
                        decoration: InputDecoration(
                          hintMaxLines: 4,
                          hintText: "Inserisci ciò che vuoi far sapere al fornitore...",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 0.0),
                          ),
                        ),
                        controller: checkoutBloc.noteController,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomButtonBar(
            color: theme.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Continua",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: theme.primaryColor,
                  onPressed: () {
                    if (cartSnapshot.data.totalItems > 0) {
                      var index = widget.controller.index;
                      widget.controller.animateTo(index + 1);
                    } else
                      Toast.show('Non hai elementi nel carrello!', context, duration: 3);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
