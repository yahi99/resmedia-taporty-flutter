import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/HeaderWidget.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/CustomerOrderPage.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/RestaurantOrderPage.dart';
import 'package:toast/toast.dart';

import 'OrderCartPage.dart';

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
  final _db = Database();

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderBloc.setOrderStream(widget.orderId);
  }

  void _askCancelConfirmation() async {
    showDialog(
      context: context,
      builder: (_context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 12.0 * 2,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Sicuro di voler annullare l'ordine?"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          EasyRouter.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          EasyRouter.pop(context);
                          try {
                            await _db.updateOrderState(widget.orderId, OrderState.CANCELLED);
                            Toast.show("Ordine consegnato", context);
                          } catch (e) {
                            print(e);
                            Toast.show("Errore inaspettato", context);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16, right: 16),
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
                            _buildTableRow("STATO", translateOrderState(order.state), color: ColorTheme.STATE_COLORS[order.state]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16, left: 20, right: 16, top: 12),
                    child: _getStateText(order),
                  ),
                  Divider(color: Colors.grey, height: 0),
                  InkWell(
                    onTap: () => EasyRouter.push(context, OrderCartPage(orderId: order.id)),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                            child: Text("Prodotto ordinati"),
                          ),
                        ),
                        Center(child: Icon(Icons.arrow_forward_ios, size: 13)),
                      ],
                    ),
                  ),
                  HeaderWidget("DATA DI CONSEGNA RICHIESTA"),
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
                            _buildTableRow("DATA", DateFormat("dd-MM-yyyy", "it").format(order.preferredDeliveryTimestamp)),
                            _buildTableRow("ORA", DateTimeHelper.getTimeString(order.preferredDeliveryTimestamp)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  HeaderWidget("INDIRIZZO DI SPEDIZIONE"),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          order.customerName,
                          style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            order.customerAddress,
                            style: TextStyle(fontSize: 14),
                          ),
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
                    child: _buildSubjectDetails(order.restaurantImageUrl, order.restaurantName, order.restaurantPhoneNumber),
                  ),
                  HeaderWidget("FATTORINO"),
                  InkWell(
                    onTap: () => EasyRouter.push(
                      context,
                      CustomerOrderPage(
                        orderId: widget.orderId,
                      ),
                    ),
                    child: _buildSubjectDetails(order.driverImageUrl, order.driverName, order.driverPhoneNumber),
                  ),
                  _buildCancelWidgets(order.state),
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

  _buildTableRow(String columnA, String columnB, {Color color}) {
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
            style: TextStyle(fontSize: 14, color: color),
          ),
        ),
      ],
    );
  }

  _buildSubjectDetails(String imageUrl, String name, String phoneNumber) {
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
                      phoneNumber,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getStateText(OrderModel order) {
    var string;
    var date;
    switch (order.state) {
      case OrderState.NEW:
        date = DateTimeHelper.getCompleteDateTimeString(order.creationTimestamp);
        string = "L'ordine è stato creato ma deve essere ancora accettato dal fornitore.";
        break;
      case OrderState.ACCEPTED:
        date = DateTimeHelper.getCompleteDateTimeString(order.acceptanceTimestamp);
        string = "L'ordine è stato accettato dal fornitore ed è in stato di preparazione.";
        break;
      case OrderState.MODIFIED:
        date = DateTimeHelper.getCompleteDateTimeString(order.modificationTimestamp);
        string = "La tua modifica deve essere accettata dal fornitore.";
        break;
      case OrderState.CANCELLED:
        date = DateTimeHelper.getCompleteDateTimeString(order.cancellationTimestamp);
        string = "Hai annullato quest'ordine.";
        break;
      case OrderState.READY:
        date = DateTimeHelper.getCompleteDateTimeString(order.readyTimestamp);
        string = "L'ordine è pronto e deve essere ritirato dal fattorino.";
        break;
      case OrderState.PICKED_UP:
        date = DateTimeHelper.getCompleteDateTimeString(order.pickupTimestamp);
        string = "L'ordine è stato preso in carico dal fattorino.";
        break;
      case OrderState.DELIVERED:
        date = DateTimeHelper.getCompleteDateTimeString(order.deliveryTimestamp);
        string = "L'ordine è arrivato a destinazione.";
        break;
      case OrderState.ARCHIVED:
        date = DateTimeHelper.getCompleteDateTimeString(order.modificationTimestamp);
        string = "L'ordine è stato archiviato dopo essere stato modificato.";
        break;
      case OrderState.REFUSED:
        date = DateTimeHelper.getCompleteDateTimeString(order.acceptanceTimestamp);
        string = "L'ordine è stato rifiutato dal fornitore.";
        break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(string),
      ],
    );
  }

  _buildCancelWidgets(OrderState state) {
    if (state == OrderState.NEW || state == OrderState.ACCEPTED || state == OrderState.READY || state == OrderState.MODIFIED) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget("ANNULLAMENTO DELL'ORDINE"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RaisedButton(
              color: ColorTheme.ACCENT_BLUE,
              onPressed: () {
                _askCancelConfirmation();
              },
              child: Text(
                "Annulla ordine",
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
          HeaderWidget("ANNULLAMENTO DELL'ORDINE"),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Non è più possibile annullare l'ordine in quanto è in consegna.",
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
