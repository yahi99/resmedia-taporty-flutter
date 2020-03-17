import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';

class CustomerDetailScreen extends StatefulWidget {
  CustomerDetailScreen({Key key}) : super(key: key);

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _db = DatabaseService();
  final _orderBloc = $Provider.of<OrderBloc>();

  void _askPermission(String orderId) async {
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
                  Text('Sicuro di avere consegnato il pacco?'),
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
                            await _db.updateOrderState(orderId, OrderState.DELIVERED);
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
        title: Text(
          "Cliente",
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
                  HeaderWidget("POSIZIONE CLIENTE"),
                  _buildMap(order),
                  HeaderWidget("INFORMAZIONI"),
                  _buildInfo(order),
                  HeaderWidget("STATO ORDINE"),
                  _buildStateComponents(order),
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

  _buildMap(OrderModel order) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        height: 260.0,
        width: double.infinity,
        child: GoogleMap(
          myLocationEnabled: false,
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(order.customerCoordinates.latitude, order.customerCoordinates.longitude),
            zoom: 13,
          ),
          markers: Set.from(
            <Marker>[
              Marker(
                markerId: MarkerId("customerCoordinates"),
                position: LatLng(order.customerCoordinates.latitude, order.customerCoordinates.longitude),
                icon: BitmapDescriptor.defaultMarker,
              ),
            ],
          ),
          onTap: (latLng) async {
            String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${order.customerCoordinates.latitude},${order.customerCoordinates.longitude}';
            if (await canLaunch(googleUrl)) {
              await launch(googleUrl);
            }
          },
        ),
      ),
    );
  }

  _buildInfo(OrderModel order) {
    final textTheme = Theme.of(context).textTheme;
    Widget imageWidget = Image(
      fit: BoxFit.cover,
      image: AssetImage("assets/img/default_profile_photo.jpg"),
    );
    if (order.customerImageUrl != null && order.customerImageUrl != "") {
      imageWidget = CachedNetworkImage(
        imageUrl: order.customerImageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: SizedBox(
            child: CircularProgressIndicator(),
            height: 50.0,
            width: 50.0,
          ),
        ),
        errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.grey)),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxWidth: 130, maxHeight: 130),
                child: Hero(
                  tag: "customerImage",
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
                        order.customerName,
                        style: textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          order.customerAddress,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RaisedButton(
                          color: ColorTheme.ACCENT_BLUE,
                          onPressed: () async {
                            if (await canLaunch("tel:${order.customerPhoneNumber}")) {
                              await launch("tel:${order.customerPhoneNumber}");
                            }
                          },
                          child: Text(
                            "Chiama",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (order.notes != null && order.notes != "")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Note dal cliente",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      order.notes,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  _buildStateComponents(OrderModel order) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Column(
        children: <Widget>[
          _getStateText(order),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (order.state == OrderState.PICKED_UP)
                RaisedButton(
                  color: ColorTheme.ACCENT_BLUE,
                  onPressed: () async {
                    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${order.customerCoordinates.latitude},${order.customerCoordinates.longitude}';
                    if (await canLaunch(googleUrl)) {
                      await launch(googleUrl);
                    }
                  },
                  child: Text(
                    "Indicazioni",
                  ),
                ),
              if (order.state == OrderState.PICKED_UP)
                RaisedButton(
                  color: ColorTheme.ACCENT_BLUE,
                  onPressed: () {
                    _askPermission(order.id);
                  },
                  child: Text(
                    "Consegnato",
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  _getStateText(OrderModel order) {
    var string;
    var date;
    if (order.state == OrderState.ACCEPTED) {
      date = DateTimeHelper.getCompleteDateTimeString(order.acceptanceTimestamp);
      string = "L'ordine è stato accettato dal fornitore ed è in stato di preparazione.";
    } else if (order.state == OrderState.READY) {
      date = DateTimeHelper.getCompleteDateTimeString(order.readyTimestamp);
      string = "L'ordine è pronto per essere ritirato presso il fornitore.";
    } else if (order.state == OrderState.PICKED_UP) {
      date = DateTimeHelper.getCompleteDateTimeString(order.pickupTimestamp);
      string = "Hai ritirato l'ordine dal fornitore.";
    } else if (order.state == OrderState.DELIVERED) {
      date = DateTimeHelper.getCompleteDateTimeString(order.deliveryTimestamp);
      string = "Hai consegnato l'ordine al cliente.";
    } else
      return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(string),
        ],
      ),
    );
  }
}
