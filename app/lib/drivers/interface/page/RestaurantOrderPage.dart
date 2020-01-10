import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/HeaderWidget.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/GoogleMapsUI.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantOrderPage extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "RestaurantOrderPage";

  String get route => RestaurantOrderPage.ROUTE;

  final OrderModel order;

  RestaurantOrderPage({Key key, this.order}) : super(key: key);

  @override
  _RestaurantOrderPageState createState() => _RestaurantOrderPageState();
}

class _RestaurantOrderPageState extends State<RestaurantOrderPage> {
  bool isDeactivate = false;

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
                  Text('Sicuro di avere ritirato il pacco?'),
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
                          print(widget.order);
                          Database().updateState(OrderState.PICKED_UP, widget.order.customerId, widget.order.id, widget.order.restaurantId, (await UserBloc.of().outUser.first).model.id);
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
    final tt = theme.textTheme;
    final cls = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Fornitore"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            EasyRouter.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWidget("POSIZIONE FORNITORE"),
            _buildMap(),
            HeaderWidget("INFORMAZIONI"),
            _buildInfo(),
            HeaderWidget("STATO ORDINE"),
            _buildStateComponents(),
          ],
        ),
      ),
    );
  }

  _buildMap() {
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
            target: LatLng(widget.order.restaurantCoordinates.latitude, widget.order.restaurantCoordinates.longitude),
            zoom: 13,
          ),
          markers: Set.from(
            <Marker>[
              Marker(
                markerId: MarkerId("restaurantCoordinates"),
                position: LatLng(widget.order.restaurantCoordinates.latitude, widget.order.restaurantCoordinates.longitude),
                icon: BitmapDescriptor.defaultMarker,
              ),
            ],
          ),
          onTap: (latLng) async {
            String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${widget.order.restaurantCoordinates.latitude},${widget.order.restaurantCoordinates.longitude}';
            if (await canLaunch(googleUrl)) {
              await launch(googleUrl);
            }
          },
        ),
      ),
    );
  }

  _buildInfo() {
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
                    imageUrl: widget.order.restaurantImageUrl,
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
                        widget.order.restaurantName,
                        style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.order.restaurantAddress,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RaisedButton(
                          color: ColorTheme.ACCENT_BLUE,
                          onPressed: () async {
                            if (await canLaunch("tel:${widget.order.restaurantPhoneNumber}")) {
                              await launch("tel:${widget.order.restaurantPhoneNumber}");
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

  _buildStateComponents() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Column(
        children: <Widget>[
          _getStateText(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (widget.order.state == OrderState.ACCEPTED || widget.order.state == OrderState.READY)
                RaisedButton(
                  color: ColorTheme.ACCENT_BLUE,
                  onPressed: () async {
                    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${widget.order.restaurantCoordinates.latitude},${widget.order.restaurantCoordinates.longitude}';
                    if (await canLaunch(googleUrl)) {
                      await launch(googleUrl);
                    }
                  },
                  child: Text(
                    "Start",
                  ),
                ),
              if (widget.order.state == OrderState.READY)
                RaisedButton(
                  color: ColorTheme.ACCENT_BLUE,
                  onPressed: () {
                    _askPermission();
                  },
                  child: Text(
                    "Ritirato",
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  _getStateText() {
    var string;
    var date;
    if (widget.order.state == OrderState.ACCEPTED) {
      date = DateTimeHelper.getCompleteDateTimeString(widget.order.acceptanceTimestamp);
      string = "L'ordine è stato accettato dal fornitore ed è in stato di preparazione.";
    } else if (widget.order.state == OrderState.READY) {
      date = DateTimeHelper.getCompleteDateTimeString(widget.order.readyTimestamp);
      string = "L'ordine è pronto per essere ritirato presso il fornitore.";
    } else if (widget.order.state == OrderState.PICKED_UP || widget.order.state == OrderState.DELIVERED) {
      date = DateTimeHelper.getCompleteDateTimeString(widget.order.pickupTimestamp);
      string = "Hai ritirato l'ordine dal fornitore.";
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
