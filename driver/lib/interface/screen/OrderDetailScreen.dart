import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:resmedia_taporty_driver/interface/page/CustomerDetailPage.dart';
import 'package:resmedia_taporty_driver/interface/page/SupplierDetailPage.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({
    Key key,
  }) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _orderBloc = $Provider.of<OrderBloc>();

  @override
  void dispose() {
    _orderBloc.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Dettaglio ordine",
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
                    onTap: () => Navigator.pushNamed(context, "/supplierDetail"),
                    child: _buildSubjectDetails(order.supplierImageUrl, order.supplierName, order.supplierAddress),
                  ),
                  HeaderWidget("CLIENTE"),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, "/clientDetail"),
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
    Widget imageWidget = Image(
      fit: BoxFit.cover,
      image: AssetImage("assets/img/default_profile_photo.jpg"),
    );
    if (imageUrl != null && imageUrl != "") {
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => SizedBox(
          height: 30.0,
          width: 30.0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.grey)),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            child: Hero(
              tag: "image",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: imageWidget,
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
