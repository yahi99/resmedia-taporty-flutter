import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/HeaderWidget.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:toast/toast.dart';

import 'OrderCartPage.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  OrderDetailPage({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final _orderBloc = OrderBloc.of();
  final _db = Database();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderBloc.setOrderStream(widget.orderId);
  }

  final _restReviewBodyKey = new GlobalKey<FormFieldState>();
  final _driverReviewBodyKey = new GlobalKey<FormFieldState>();
  double _restRating = 5;
  double _driverRating = 5;

  // TODO: Metti in un widget a sè stante e definisci il ReviewModel
  void _addSupplierReview(OrderModel order) {
    showDialog(
      context: context,
      builder: (_context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    child: AutoSizeText('Recensione fornitore'),
                    padding: EdgeInsets.only(bottom: 12.0, right: 12.0),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RatingBar(
                    initialRating: 5,
                    onRatingChanged: (val) {
                      _restRating = val;
                    },
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    halfFilledIcon: Icons.star_half,
                    isHalfAllowed: true,
                    emptyColor: Colors.yellow,
                    filledColor: Colors.yellow,
                    halfFilledColor: Colors.yellow,
                    size: 25.0,
                  ),
                ],
              ),
              Padding(
                child: TextFormField(
                  key: _restReviewBodyKey,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value.length == 0) {
                      return 'Inserisci valutazione';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Inserisci una recensione...",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                  ),
                  maxLines: 10,
                  minLines: 5,
                  keyboardType: TextInputType.text,
                ),
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Invia'),
                    onPressed: () async {
                      try {
                        await _db.addSupplierReview(order.supplierId, order.customerId, order.customerName, order.id, _restRating, _restReviewBodyKey.currentState.value);
                        Toast.show("Recensione aggiunta con successo!", context);
                        Navigator.pop(context);
                      } catch (err) {
                        Toast.show("Errore inaspettato!", context);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // TODO: Refactor
  void _addDriverReview(OrderModel order) {
    showDialog(
      context: context,
      builder: (_context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    child: AutoSizeText('Recensione fattorino'),
                    padding: EdgeInsets.only(bottom: 12.0, right: 12.0),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RatingBar(
                    initialRating: 5,
                    onRatingChanged: (val) {
                      _driverRating = val;
                    },
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    halfFilledIcon: Icons.star_half,
                    isHalfAllowed: true,
                    emptyColor: Colors.yellow,
                    filledColor: Colors.yellow,
                    halfFilledColor: Colors.yellow,
                    size: 25.0,
                  ),
                ],
              ),
              Padding(
                child: TextFormField(
                  key: _driverReviewBodyKey,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value.length == 0) {
                      return 'Inserisci valutazione';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Inserisci una recensione...",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                  ),
                  maxLines: 10,
                  minLines: 5,
                  keyboardType: TextInputType.text,
                ),
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Invia'),
                    onPressed: () async {
                      try {
                        await _db.addDriverReview(order.driverId, order.customerId, order.customerName, order.id, _driverRating, _driverReviewBodyKey.currentState.value);
                        Toast.show("Recensione aggiunta con successo!", context);
                        Navigator.pop(context);
                      } catch (err) {
                        Toast.show("Errore inaspettato!", context);
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
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
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          Navigator.pop(context);
                          try {
                            await _db.updateOrderState(widget.orderId, OrderState.CANCELLED);
                            Toast.show("Ordine cancellato", context);
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderCartPage(orderId: order.id),
                      ),
                    ),
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
                  if (order.hasSupplierReview != true && order.state == OrderState.DELIVERED)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildSubjectDetails(order.supplierImageUrl, order.supplierName, order.supplierPhoneNumber),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                          child: InkWell(
                            onTap: () => _addSupplierReview(order),
                            child: Text(
                              "Lascia una recensione",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: ColorTheme.BLUE,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (order.hasSupplierReview == true || order.state != OrderState.DELIVERED) _buildSubjectDetails(order.supplierImageUrl, order.supplierName, order.supplierPhoneNumber),
                  HeaderWidget("FATTORINO"),
                  if (order.hasDriverReview != true && order.state == OrderState.DELIVERED)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildSubjectDetails(order.driverImageUrl, order.driverName, order.driverPhoneNumber),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                          child: InkWell(
                            onTap: () => _addDriverReview(order),
                            child: Text(
                              "Lascia una recensione",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: ColorTheme.BLUE,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (order.hasDriverReview == true || order.state != OrderState.DELIVERED) _buildSubjectDetails(order.driverImageUrl, order.driverName, order.driverPhoneNumber),
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
