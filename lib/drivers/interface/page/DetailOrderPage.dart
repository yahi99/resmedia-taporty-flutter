import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/drivers/interface/page/SubjectOrderPage.dart';
import 'package:mobile_app/drivers/interface/tab/OrdersTab.dart';
import 'package:mobile_app/drivers/interface/view/OrderView.dart';
import 'package:mobile_app/drivers/interface/widget/GoogleMapsUI.dart';
import 'package:mobile_app/drivers/interface/widget/Order.dart';
import 'package:mobile_app/drivers/model/OrderModel.dart';


class DetailOrderPageDriver extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "DetailOrderPageDriver";
  String get route => DetailOrderPageDriver.ROUTE;

  final DriverOrderModel model;

  DetailOrderPageDriver({Key key,
    @required this.model,
  }) : super(key: key);

  @override
  _DetailOrderPageDriverState createState() => _DetailOrderPageDriverState();
}

class _DetailOrderPageDriverState extends State<DetailOrderPageDriver> {
  bool isDeactivate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //initMap(context);
  }

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  /*initMap(BuildContext context) async {
    if (isDeactivate) return;
    await PrimaryGoogleMapsController.of(context).future
    ..setMarkers(widget.model.subjects.map((subject) {
      return Marker(
        markerId: MarkerId(subject.title),
        position: subject.toLatLng(),
        infoWindow: InfoWindow(
          title: subject.title,
          onTap: () => EasyRouter.push(context, SubjectOrderPageDriver(model: subject,)),
        ),
      );
    }).toSet())
    ..animateToCenter(widget.model.positions);
  }*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final sub=widget.model.subjects;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const RubberConcierge(),
      ),
      body: ListView(
        controller: RubberScrollController.of(context),
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(SPACE),
            child: Wrap(
              runSpacing: 16.0,
              children: <Widget>[
                Text("DETTAGLIO ORDINE", style: tt.title,),
                InkWell(
                  onTap: () => EasyRouter.push(context, SubjectOrderPageDriver(model: sub[0],)),
                  child: Order(
                    children: <Widget>[
                      SubjectVoid(model: sub[0],),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => EasyRouter.push(context, SubjectOrderPageDriver(model: sub[1],)),
                  child: Order(
                    children: <Widget>[
                      SubjectVoid(model: sub[1], subject: Subject.RECEIVER,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}