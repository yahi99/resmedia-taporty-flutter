import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/interface/widget/ProductNoteDialog.dart';
import 'package:resmedia_taporty_customer/interface/widget/StepperButton.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

class ProductView extends StatefulWidget {
  final ProductModel product;
  final bool modifiable;

  ProductView(this.product, {this.modifiable = true, key}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final CartBloc cartBloc = $Provider.of<CartBloc>();

  void openProductNoteDialog(CartProductModel cartProduct) {
    showDialog(
      context: context,
      builder: (_context) {
        return ProductNoteDialog(
          defaultNotes: cartProduct.notes,
          onConfirm: (notes) async {
            try {
              $Provider.of<CartBloc>().setProductNote(cartProduct.id, notes);
              Toast.show("Nota aggiunta con successo!", context);
              Navigator.pop(context);
            } catch (err) {
              print(err);
              Toast.show("Errore inaspettato!", context);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTextStyle(
      style: theme.textTheme.body1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                if (widget.product.imageUrl != null && widget.product.imageUrl != "") ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      height: 90,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.product.imageUrl,
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
                  ),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AutoSizeText(
                        widget.product.name,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (widget.product.description != null && widget.product.description != "")
                        AutoSizeText(
                          widget.product.description,
                          maxLines: 3,
                          minFontSize: 12,
                          maxFontSize: 14,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '€ ${widget.product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      if (widget.modifiable)
                        StreamBuilder<CartModel>(
                          stream: cartBloc.outCart,
                          builder: (context, cartSnapshot) {
                            if (!cartSnapshot.hasData) return Container();
                            var cart = cartSnapshot.data;
                            var cartProduct = cart.getProduct(widget.product.id);
                            if (cartProduct == null || cartProduct.quantity < 1) return Container();
                            var hasNotes = cartProduct.notes != null && cartProduct.notes.isNotEmpty;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                onTap: () => openProductNoteDialog(cartProduct),
                                child: AutoSizeText(
                                  hasNotes ? "Modifica nota" : "Aggiungi una nota",
                                  maxLines: 1,
                                  maxFontSize: 12,
                                  minFontSize: 8,
                                  style: TextStyle(fontSize: 12, color: ColorTheme.ACCENT_BLUE),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.modifiable)
            StreamBuilder<CartModel>(
              stream: cartBloc.outCart,
              builder: (context, cartSnapshot) {
                if (!cartSnapshot.hasData) return Container();
                var cart = cartSnapshot.data;
                var cartProduct = cart.getProduct(widget.product.id);
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
                    cartBloc.decrease(widget.product.id);
                    Vibration.vibrate(duration: 65);
                  },
                  onIncrement: () {
                    if (cartProduct != null) {
                      if (widget.product.maxQuantity != 0 && widget.product.maxQuantity <= cartProduct.quantity) {
                        Toast.show("Massima quantità ordinabile raggiunta", context, duration: 3);
                        return;
                      }
                      Vibration.vibrate(duration: 65);
                      cartBloc.increment(cartProduct.id);
                    } else {
                      Vibration.vibrate(duration: 65);
                      cartBloc.add(widget.product);
                    }
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
