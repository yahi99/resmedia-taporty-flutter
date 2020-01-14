import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/HeaderWidget.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

class ModifyOrderCartPage extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "ModifyOrderCartPage";

  String get route => ModifyOrderCartPage.ROUTE;

  final OrderModel order;

  ModifyOrderCartPage({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  _ModifyOrderCartPageState createState() => _ModifyOrderCartPageState();
}

class _ModifyOrderCartPageState extends State<ModifyOrderCartPage> {
  RestaurantBloc _restBloc;
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
  void didChangeDependencies() {
    _restBloc = RestaurantBloc.init(restaurantId: widget.order.restaurantId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Modifica prodotti",
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            EasyRouter.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: _restBloc.outProducts,
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
                            EasyRouter.pop(context);
                          },
                          child: Text(
                            "Annulla",
                          ),
                        ),
                        RaisedButton(
                          color: ColorTheme.ACCENT_BLUE,
                          onPressed: () async {
                            try {
                              await Database().modifyOrder(widget.order.id, widget.order.state, orderProducts);
                              EasyRouter.pop(context);
                              Toast.show("Modifica inviata", context);
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
