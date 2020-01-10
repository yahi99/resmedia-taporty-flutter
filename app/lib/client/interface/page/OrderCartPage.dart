import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/HeaderWidget.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';

class OrderCartPage extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrderCartPage";

  String get route => OrderCartPage.ROUTE;

  final String orderId;

  OrderCartPage({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  @override
  _OrderCartPageState createState() => _OrderCartPageState();
}

class _OrderCartPageState extends State<OrderCartPage> {
  bool isDeactivate = false;
  final _orderBloc = OrderBloc.of();

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderBloc.setOrderStream(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Prodotti ordinati",
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            EasyRouter.pop(context);
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
                                      child: Image.network(
                                        products[index].imageUrl,
                                        fit: BoxFit.fitHeight,
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
                  _buildModifyWidgets(orderSnapshot.data.state),
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

  _buildModifyWidgets(OrderState state) {
    if (state == OrderState.NEW || state == OrderState.ACCEPTED || state == OrderState.READY) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget("MODIFICA DELL'ORDINE"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RaisedButton(
              color: ColorTheme.ACCENT_BLUE,
              onPressed: () {},
              child: Text(
                "Modifica ordine",
              ),
            ),
          )
        ],
      );
    }
    if (state == OrderState.PICKED_UP) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget("MODIFICA DELL'ORDINE"),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Non è più possibile modificare l'ordine in quanto è in consegna.",
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
