import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_customer/interface/screen/ModifyOrderCartScreen.dart';

class OrderCartScreen extends StatefulWidget {
  OrderCartScreen({
    Key key,
  }) : super(key: key);

  @override
  _OrderCartScreenState createState() => _OrderCartScreenState();
}

class _OrderCartScreenState extends State<OrderCartScreen> {
  final _orderBloc = $Provider.of<OrderBloc>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Prodotti ordinati",
          style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<OrderModel>(
        stream: _orderBloc.outOrder,
        builder: (_, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.active && orderSnapshot.hasData && orderSnapshot.data != null) {
            var products = orderSnapshot.data.state == OrderState.MODIFIED ? orderSnapshot.data.newProducts : orderSnapshot.data.products;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultTextStyle(
                          style: theme.textTheme.body1,
                          child: SizedBox(
                            height: 110,
                            child: Row(
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
                                    Text('€ ${products[index].price.toStringAsFixed(2)} x${products[index].quantity}'),
                                  ],
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
                  _buildModifyWidgets(orderSnapshot.data),
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

  _buildModifyWidgets(OrderModel order) {
    if (order.state == OrderState.NEW) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget("MODIFICA DELL'ORDINE"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RaisedButton(
              color: ColorTheme.ACCENT_BLUE,
              onPressed: () {
                $Provider.of<SupplierBloc>().setSupplier(order.supplierId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifyOrderCartScreen(
                      order: order,
                    ),
                  ),
                );
              },
              child: Text(
                "Modifica ordine",
              ),
            ),
          )
        ],
      );
    }
    if (order.state == OrderState.PICKED_UP || order.state == OrderState.ACCEPTED || order.state == OrderState.READY) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget("MODIFICA DELL'ORDINE"),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Non è più possibile modificare l'ordine in quanto è già stato accettato.",
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
