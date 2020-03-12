import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/ReviewBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/widget/ReviewAlertDialog.dart';
import 'package:toast/toast.dart';
import 'package:resmedia_taporty_customer/blocs/OrderBloc.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({
    Key key,
  }) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _orderBloc = $Provider.of<OrderBloc>();
  final _reviewBloc = $Provider.of<ReviewBloc>();
  final _db = DatabaseService();

  @override
  void dispose() {
    _orderBloc.clear();
    super.dispose();
  }

  void _addSupplierReview(ReviewModel review) {
    _reviewBloc.setReviewType(true);
    showDialog(
      context: context,
      builder: (_context) {
        return ReviewAlertDialog(review, true);
      },
    );
  }

  void _addDriverReview(ReviewModel review) {
    _reviewBloc.setReviewType(false);
    showDialog(
      context: context,
      builder: (_context) {
        return ReviewAlertDialog(review, false);
      },
    );
  }

  void _askCancelConfirmation(OrderModel order) async {
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
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            await _db.updateOrderState(order.id, OrderState.CANCELLED);
                            Toast.show("Ordine cancellato", context);
                          } on InvalidOrderStateException catch (err) {
                            print(err);
                            Toast.show("L'ordine ha cambiato stato e non può più essere annullato.", context);
                            Navigator.pop(context);
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
                            1: FlexColumnWidth(1),
                          },
                          children: [
                            _buildTableRow("CODICE", order.id),
                            _buildTableRow("DATA", DateFormat("dd-MM-yyyy", "it").format(order.creationTimestamp)),
                            _buildTableRow("STATO", translateOrderState(order.state), color: ColorTheme.STATE_COLORS[order.state]),
                            _buildTableRow("PRODOTTI", order.cartAmount.toStringAsFixed(2) + " €"),
                            _buildTableRow("SPEDIZIONE", order.deliveryAmount.toStringAsFixed(2) + " €"),
                            _buildTableRow("TOTALE", (order.cartAmount + order.deliveryAmount).toStringAsFixed(2) + " €"),
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
                    onTap: () => Navigator.pushNamed(context, "/orderCart"),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildSubjectDetails(order.supplierImageUrl, order.supplierName, order.supplierPhoneNumber),
                      if (order.state == OrderState.DELIVERED)
                        StreamBuilder<ReviewModel>(
                          stream: _reviewBloc.outSupplierReview,
                          builder: (context, reviewSnap) {
                            if (reviewSnap.hasData && order.hasSupplierReview)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        RatingBar.readOnly(
                                          initialRating: reviewSnap.data.rating,
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          halfFilledIcon: Icons.star_half,
                                          isHalfAllowed: true,
                                          emptyColor: Colors.yellow,
                                          filledColor: Colors.yellow,
                                          halfFilledColor: Colors.yellow,
                                          size: 26,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                    child: InkWell(
                                      onTap: () => _addSupplierReview(reviewSnap.data),
                                      child: Text(
                                        "Modifica la recensione",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: ColorTheme.BLUE,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            else
                              return Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                child: InkWell(
                                  onTap: () => _addSupplierReview(null),
                                  child: Text(
                                    "Lascia una recensione",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: ColorTheme.BLUE,
                                    ),
                                  ),
                                ),
                              );
                          },
                        ),
                    ],
                  ),
                  HeaderWidget("FATTORINO"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildSubjectDetails(order.driverImageUrl, order.driverName, order.driverPhoneNumber),
                      if (order.state == OrderState.DELIVERED)
                        StreamBuilder<ReviewModel>(
                          stream: _reviewBloc.outDriverReview,
                          builder: (context, reviewSnap) {
                            if (reviewSnap.hasData && order.hasDriverReview)
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        RatingBar.readOnly(
                                          initialRating: reviewSnap.data.rating,
                                          filledIcon: Icons.star,
                                          emptyIcon: Icons.star_border,
                                          halfFilledIcon: Icons.star_half,
                                          isHalfAllowed: true,
                                          emptyColor: Colors.yellow,
                                          filledColor: Colors.yellow,
                                          halfFilledColor: Colors.yellow,
                                          size: 26,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                    child: InkWell(
                                      onTap: () => _addDriverReview(reviewSnap.data),
                                      child: Text(
                                        "Modifica la recensione",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: ColorTheme.BLUE,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            else
                              return Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                                child: InkWell(
                                  onTap: () => _addDriverReview(null),
                                  child: Text(
                                    "Lascia una recensione",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: ColorTheme.BLUE,
                                    ),
                                  ),
                                ),
                              );
                          },
                        ),
                    ],
                  ),
                  _buildCancelWidgets(order),
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
          if (imageUrl != null)
            Container(
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: imageWidget,
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
                  if (phoneNumber != null)
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
      /*case OrderState.MODIFIED:
        date = DateTimeHelper.getCompleteDateTimeString(order.modificationTimestamp);
        string = "La tua modifica deve essere accettata dal fornitore.";
        break;*/
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
        date = DateTimeHelper.getCompleteDateTimeString(order.archiviationTimestamp);
        string = "L'ordine è stato archiviato dopo essere stato modificato.";
        break;
      case OrderState.REFUSED:
        date = DateTimeHelper.getCompleteDateTimeString(order.refusalTimestamp);
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

  _buildCancelWidgets(OrderModel order) {
    if (order.state == OrderState.NEW) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget("ANNULLAMENTO DELL'ORDINE"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: RaisedButton(
              color: ColorTheme.ACCENT_BLUE,
              onPressed: () {
                _askCancelConfirmation(order);
              },
              child: Text(
                "Annulla ordine",
              ),
            ),
          )
        ],
      );
    }
    if (order.state == OrderState.PICKED_UP || order.state == OrderState.ACCEPTED || order.state == OrderState.READY /*|| order.state == OrderState.MODIFIED*/) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget("ANNULLAMENTO DELL'ORDINE"),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Non è più possibile annullare l'ordine in quanto è stato accettato dal fornitore.",
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
