import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/HeaderWidget.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/CustomerOrderPage.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/RestaurantOrderPage.dart';

class OrderDetailPage extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrderDetailPage";

  String get route => OrderDetailPage.ROUTE;

  final String orderId;

  OrderDetailPage({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Dettaglio ordine",
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
            var order = orderSnapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(3),
                          },
                          children: [
                            _buildTableRow("CODICE", order.id),
                            _buildTableRow("DATA", DateFormat("dd-MM-yyyy", "it").format(order.creationTimestamp)),
                            _buildTableRow("TOTALE", order.totalPrice.toStringAsFixed(2) + " €"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  HeaderWidget("DETTAGLI CONSEGNA"),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Table(
                          children: [
                            _buildTableRow("STATO", translateOrderState(order.state)),
                            _buildTableRow("DATA CONSEGNA", DateFormat("dd-MM-yyyy", "it").format(order.preferredDeliveryTimestamp)),
                            _buildTableRow("ORA CONSEGNA", DateTimeHelper.getTimeString(order.preferredDeliveryTimestamp)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  HeaderWidget("FORNITORE"),
                  InkWell(
                    onTap: () => EasyRouter.push(
                      context,
                      RestaurantOrderPage(
                        orderId: widget.orderId,
                      ),
                    ),
                    child: _buildSubjectDetails(order.restaurantImageUrl, order.restaurantName, order.restaurantAddress),
                  ),
                  HeaderWidget("CLIENTE"),
                  InkWell(
                    onTap: () => EasyRouter.push(
                      context,
                      CustomerOrderPage(
                        orderId: widget.orderId,
                      ),
                    ),
                    child: _buildSubjectDetails(order.customerImageUrl, order.customerName, order.customerAddress),
                  ),
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

  _buildTableRow(String columnA, String columnB) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            columnA,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            columnB,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  _buildSubjectDetails(String imageUrl, String name, String address) {
    var textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    height: 30.0,
                    width: 30.0,
                  ),
                ),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.grey)),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      address,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(child: Icon(Icons.arrow_forward_ios)),
        ],
      ),
    );
  }
}
