import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
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
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                      var orderProduct = orderProducts.firstWhere((p) => p.id == products[index].id, orElse: () => null);
                      var quantity = 0;
                      if (orderProduct != null) quantity = orderProduct.quantity;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultTextStyle(
                          style: theme.textTheme.body1,
                          child: SizedBox(
                            height: 110,
                            child: Row(
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
                                            imageUrl: products[index].imageUrl,
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
                                          child: Container(child: Text(products[index].name), width: MediaQuery.of(context).size.width * 2 / 5),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                StepperButton(
                                  direction: Axis.vertical,
                                  child: Text(quantity.toString()),
                                  onDecrease: () {
                                    if (orderProduct != null) {
                                      if (orderProduct.quantity == 0) return;
                                      this.setState(() => orderProduct.quantity--);
                                    }
                                  },
                                  onIncrement: () {
                                    if (orderProduct != null) {
                                      if (products[index].maxQuantity == orderProduct.quantity) {
                                        Toast.show("Massima quantità ordinabile raggiunta", context);
                                      }
                                      Vibration.vibrate(duration: 65);
                                      this.setState(() => orderProduct.quantity++);
                                    } else {
                                      var p = products[index];
                                      this.setState(() => orderProducts.add(OrderProductModel(id: p.id, name: p.name, quantity: 1, imageUrl: p.imageUrl, price: p.price)));
                                    }
                                  },
                                ),
                              ],
                            ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          color: ColorTheme.ACCENT_BLUE,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Annulla",
                          ),
                        ),
                        RaisedButton(
                          color: ColorTheme.ACCENT_BLUE,
                          onPressed: () async {
                            try {
                              await $Provider.of<OrderBloc>().modifyOrder(orderProducts);
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
