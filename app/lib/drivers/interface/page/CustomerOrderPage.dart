import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/HeaderWidget.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerOrderPage extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "CustomerOrderPage";

  String get route => CustomerOrderPage.ROUTE;

  final String orderId;

  CustomerOrderPage({Key key, this.orderId}) : super(key: key);

  @override
  _CustomerOrderPageState createState() => _CustomerOrderPageState();
}

class _CustomerOrderPageState extends State<CustomerOrderPage> {
  bool isDeactivate = false;
  final _db = Database();
  final _orderBloc = OrderBloc.of();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderBloc.setOrderStream(widget.orderId);
  }

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  void _askPermission() async {
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
                          EasyRouter.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          EasyRouter.pop(context);
                          try {
                            await _db.updateOrderState(widget.orderId, OrderState.DELIVERED);
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cliente"),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: CachedNetworkImage(
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
                        style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
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
                    "Start",
                  ),
                ),
              if (order.state == OrderState.PICKED_UP)
                RaisedButton(
                  color: ColorTheme.ACCENT_BLUE,
                  onPressed: () {
                    _askPermission();
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
