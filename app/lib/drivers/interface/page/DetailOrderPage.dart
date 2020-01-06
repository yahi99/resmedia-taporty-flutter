import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/SubjectOrderPage.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/OrderView.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/Order.dart';

import '../widget/GoogleMapsUI.dart';

class DetailOrderPageDriver extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "DetailOrderPageDriver";

  String get route => DetailOrderPageDriver.ROUTE;

  final OrderModel model;

  DetailOrderPageDriver({
    Key key,
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

  initMap(BuildContext context) async {
    if (isDeactivate) return;
    await PrimaryGoogleMapsController.of(context).future
      ..setMarkers(widget.model.subjects.map((subject) {
        return Marker(
          markerId: MarkerId(subject.name),
          position: subject.position,
          infoWindow: InfoWindow(
            title: subject.name,
            onTap: () => EasyRouter.push(
                context,
                SubjectOrderPageDriver(
                  model: subject,
                )),
          ),
        );
      }).toSet())
      ..animateToCenter(widget.model.positions);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final sub = widget.model.subjects;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            EasyRouter.pop(context);
          },
        ),
        //title: const RubberConcierge(),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(SPACE),
            child: Wrap(
              runSpacing: 16.0,
              children: <Widget>[
                Text(
                  "DETTAGLIO ORDINE",
                  style: tt.title,
                ),
                InkWell(
                  onTap: () => EasyRouter.push(
                    context,
                    SubjectOrderPageDriver(
                      orderModel: widget.model,
                      model: sub[0],
                      isRest: true,
                    ),
                  ),
                  child: Order(
                    children: <Widget>[
                      Expanded(
                        child: SubjectVoid(
                          model: sub[0],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => EasyRouter.push(
                      context,
                      SubjectOrderPageDriver(
                        orderModel: widget.model,
                        model: sub[1],
                        isRest: false,
                      )),
                  child: Order(
                    children: <Widget>[
                      Expanded(
                        child: SubjectVoid(
                          model: sub[1],
                          subject: Subject.RECEIVER,
                        ),
                      ),
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
