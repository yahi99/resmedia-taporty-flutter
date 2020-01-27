import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/interface/widget/StepperButton.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

class ProductView extends StatelessWidget {
  final ProductModel product;

  final CartBloc cartBloc = $Provider.of<CartBloc>();

  ProductView({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.body1,
      child: SizedBox(
        height: 110,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.fitHeight,
                        placeholder: (context, url) => SizedBox(
                          height: 30.0,
                          width: 30.0,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.grey)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Container(child: Text(product.name), width: MediaQuery.of(context).size.width * 2 / 5),
                    ),
                    Text('€ ${product.price.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
            StreamBuilder<CartModel>(
              stream: cartBloc.outCart,
              builder: (context, cartSnapshot) {
                if (!cartSnapshot.hasData) return Container();
                var cart = cartSnapshot.data;
                var cartProduct = cart.getProduct(product.id);
                return StepperButton(
                  direction: Axis.vertical,
                  child: Text(cartProduct?.quantity?.toString() ?? "0"),
                  onDecrease: () {
                    cartBloc.decrease(product.id);
                    Vibration.vibrate(duration: 65);
                  },
                  onIncrement: () {
                    if (cartProduct != null) {
                      if (product.maxQuantity != 0 && product.maxQuantity <= cartProduct.quantity) {
                        Toast.show("Massima quantità ordinabile raggiunta", context, duration: 3);
                        return;
                      }
                      Vibration.vibrate(duration: 65);
                      cartBloc.increment(cartProduct.id);
                    } else {
                      Vibration.vibrate(duration: 65);
                      cartBloc.add(product);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
