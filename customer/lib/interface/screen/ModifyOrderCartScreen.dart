import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/widget/ProductNoteDialog.dart';
import 'package:resmedia_taporty_customer/interface/widget/StepperButton.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/OrderBloc.dart';

class ModifyOrderCartScreen extends StatefulWidget {
  final OrderModel order;

  ModifyOrderCartScreen({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  _ModifyOrderCartScreenState createState() => _ModifyOrderCartScreenState();
}

class _ModifyOrderCartScreenState extends State<ModifyOrderCartScreen> {
  SupplierBloc supplierBloc = $Provider.of<SupplierBloc>();
  OrderBloc orderBloc = $Provider.of<OrderBloc>();
  List<OrderProductModel> orderProducts;

  @override
  void initState() {
    orderProducts = widget.order.products
        .map((product) => OrderProductModel(
              id: product.id,
              imageUrl: product.imageUrl,
              name: product.name,
              quantity: product.quantity,
              price: product.price,
              notes: product.notes,
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    // Determina se l'ordine ha delle modifiche sui prodotti ordinati o sulle note
    var hasModifications = false;
    for (var p in orderProducts) {
      var found = widget.order.products.firstWhere((p1) => p.id == p1.id, orElse: () => null);
      if (found == null && p.quantity == 0) continue;
      if (found == null || p.quantity != found.quantity || p.notes != found.notes) {
        hasModifications = true;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Modifica prodotti",
          style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: supplierBloc.outProducts,
        builder: (_, productListSnapshot) {
          if (productListSnapshot.connectionState == ConnectionState.active && productListSnapshot.hasData) {
            var products = productListSnapshot.data;
            products.sort((a, b) {
              if (widget.order.products.firstWhere((p) => p.id == b.id, orElse: () => null) == null) return -1;
              if (widget.order.products.firstWhere((p) => p.id == a.id, orElse: () => null) == null) return 1;
              return -1;
            });
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      var product = products[index];
                      var orderProduct = orderProducts.firstWhere((p) => p.id == product.id, orElse: () => null);
                      var quantity = 0;
                      var notes = "";
                      if (orderProduct != null) {
                        quantity = orderProduct.quantity;
                        notes = orderProduct.notes ?? "";
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultTextStyle(
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
                                    if (product.imageUrl != null && product.imageUrl != "") ...[
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Container(
                                          height: 90,
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
                                          if (quantity > 0)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_context) {
                                                      return ProductNoteDialog(
                                                        defaultNotes: notes,
                                                        onConfirm: (notes) async {
                                                          try {
                                                            this.setState(() => orderProduct.notes = notes);
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
                                                },
                                                child: AutoSizeText(
                                                  notes == "" ? "Aggiungi una nota" : "Modifica nota",
                                                  maxLines: 1,
                                                  maxFontSize: 14,
                                                  minFontSize: 10,
                                                  style: TextStyle(fontSize: 13, color: ColorTheme.ACCENT_BLUE),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: StepperButton(
                                  backgroundColor: ColorTheme.ACCENT_BLUE,
                                  padding: EdgeInsets.all(3),
                                  direction: Axis.vertical,
                                  child: AutoSizeText(
                                    quantity.toString() ?? "0",
                                    maxLines: 1,
                                    minFontSize: 10,
                                  ),
                                  onDecrease: () {
                                    if (orderProduct != null) {
                                      if (orderProduct.quantity == 0) return;
                                      this.setState(() => orderProduct.quantity--);
                                    }
                                  },
                                  onIncrement: () {
                                    if (orderProduct != null) {
                                      if (product.maxQuantity != 0 && product.maxQuantity == orderProduct.quantity) {
                                        Toast.show("Massima quantità ordinabile raggiunta", context);
                                        return;
                                      }
                                      Vibration.vibrate(duration: 65);
                                      this.setState(() => orderProduct.quantity++);
                                    } else {
                                      this.setState(
                                        () => orderProducts.add(
                                          OrderProductModel(
                                            id: product.id,
                                            name: product.name,
                                            quantity: 1,
                                            imageUrl: product.imageUrl,
                                            price: product.price,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.grey,
                      height: 0,
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0,
                  ),
                  if (hasModifications)
                    StreamBuilder<bool>(
                      stream: orderBloc.outConfirmLoading,
                      builder: (context, loadingSnap) {
                        var loading = loadingSnap.data ?? false;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RaisedButton(
                                color: ColorTheme.ACCENT_BLUE,
                                onPressed: loading
                                    ? null
                                    : () {
                                        Navigator.pop(context);
                                      },
                                child: Text(
                                  "Annulla",
                                ),
                              ),
                              RaisedButton(
                                color: ColorTheme.ACCENT_BLUE,
                                onPressed: loading
                                    ? null
                                    : () async {
                                        try {
                                          var newOrderId = await $Provider.of<OrderBloc>().modifyOrder(orderProducts);
                                          orderBloc.setOrderStream(newOrderId);
                                          Navigator.pop(context);
                                          Toast.show("Modifica inviata", context);
                                        } on PaymentIntentException catch (err) {
                                          Toast.show(err.message, context);
                                        } on InvalidOrderStateException catch (err) {
                                          print(err);
                                          Toast.show("L'ordine ha cambiato stato e non può più essere modificato.", context);
                                          Navigator.pop(context);
                                        } catch (err) {
                                          print(err);
                                          Toast.show("Errore inaspettato!", context);
                                        }
                                      },
                                child: Text(
                                  "Invia modifica",
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
