import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/interface/view/ProductView.dart';

class CartProductListView extends StatelessWidget {
  final CartModel cart;
  final bool modifiable;

  CartProductListView({Key key, @required this.cart, this.modifiable = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HeaderWidget("Carrello"),
        if (cart.supplierProducts.length > 0) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cart.supplierProducts.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ProductView(cart.supplierProducts[index], modifiable: modifiable),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Prezzo prodotti: ',
                    ),
                    Text((cart.totalPrice.toStringAsFixed(2)) + "€"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Prezzo consegna: ',
                    ),
                    Text("5.00€"), // TODO: Prendi il prezzo di consegna dal database
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Totale: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ((cart.totalPrice + 5).toStringAsFixed(2)) + "€",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ] else
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Il carrello è vuoto."),
          )
      ],
    );
  }
}
