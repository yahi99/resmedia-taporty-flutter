import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/interface/widget/StepperButton.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

class ProductView extends StatelessWidget {
  final ProductModel product;

  final CartBloc cartBloc = $Provider.of<CartBloc>();

  ProductView(this.product, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.body1,
      child: SizedBox(
        height: 90,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (product.imageUrl != null && product.imageUrl != "") ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
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
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AutoSizeText(
                          product.name,
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (product.description != null && product.description != "")
                          AutoSizeText(
                            product.description,
                            maxLines: 3,
                            minFontSize: 12,
                            maxFontSize: 14,
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '€ ${product.price.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<CartModel>(
              stream: cartBloc.outCart,
              builder: (context, cartSnapshot) {
                if (!cartSnapshot.hasData) return Container();
                var cart = cartSnapshot.data;
                var cartProduct = cart.getProduct(product.id);
                return StepperButton(
                  backgroundColor: ColorTheme.ACCENT_BLUE,
                  direction: Axis.vertical,
                  padding: EdgeInsets.all(3),
                  child: AutoSizeText(
                    cartProduct?.quantity?.toString() ?? "0",
                    maxLines: 1,
                    minFontSize: 10,
                  ),
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
