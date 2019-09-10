import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/GoogleMapsUI.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/utility/google_maps_widget.dart';
import 'package:toast/toast.dart';

class SubjectOrderPageDriver extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "SubjectOrderPageDriver";

  String get route => SubjectOrderPageDriver.ROUTE;

  final SubjectModel model;
  final DriverOrderModel orderModel;

  SubjectOrderPageDriver(
      {Key key, @required this.model, @required this.orderModel})
      : super(key: key);

  @override
  _SubjectOrderPageDriverState createState() => _SubjectOrderPageDriverState();
}

class _SubjectOrderPageDriverState extends State<SubjectOrderPageDriver> {
  bool isDeactivate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initMap(context);
  }

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  initMap(BuildContext context) async {
    if (isDeactivate) return;
    await PrimaryGoogleMapsController.of(context).future
      ..animateCamera(CameraUpdate.newLatLng(widget.model.toLatLng()));
  }

  void _askPermission(BuildContext context, String state) async {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        final cls = theme.colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text((state == 'PICKED_UP')
                      ? 'Sei sicuro di avere ritirato il pacco?'
                      : 'Sei sicuro di aver consegnato il pacco?'),
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
                          Database().updateState(
                              state,
                              widget.orderModel.uid,
                              widget.orderModel.id,
                              widget.orderModel.restId,
                              (await UserBloc.of().outUser.first).model.id);
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
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed: (){
            EasyRouter.pop(context);
          },),
        //title: const RubberConcierge(),
      ),
      body: ListViewSeparated(
        //controller: RubberScrollController.of(context),
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(SPACE),
        separator: const SizedBox(
          height: 8.0,
        ),
        children: <Widget>[
          Text(
            "",
            style: tt.title,
          ),
          Wrap(
            runSpacing: 8.0,
            children: <Widget>[
              Container(
                color: Colors.grey[300],
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.model.title,
                            style: tt.subtitle,
                          ),
                          Text(
                            "${(widget.model.address.length > 28) ? widget.model.address.substring(0, 28) + '\n' + widget.model.address.substring(28) : widget.model.address}",
                            style: tt.subhead,
                          ),
                          Text(
                            "${(widget.model.time.length > 10) ? widget.model.time.substring(0, 10) + '\n' + widget.model.time.substring(10) : widget.model.time}",
                            style: tt.subhead,
                          ),
                        ],
                      ),
                    ),
                    /*Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          color: cls.secondaryVariant,
                          onPressed: () {},
                          child: Text(
                            "Chiama",
                            style: tt.button,
                          ),
                        ),
                      ),*/
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Tempo di arrivo stimato",
                      style: tt.subtitle,
                    ),
                    Text(
                      "${(widget.model.address.length > 30) ? widget.model.address.substring(0, 28) + '\n' + widget.model.address.substring(28) : widget.model.address}",
                      style: tt.subhead,
                    ),
                    Text(
                      widget.model.time,
                      style: tt.subhead,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(SPACE),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: cls.secondaryVariant,
                      onPressed: () async {
                        //TODO: qui và modificata la mappa mettendo il percorso
                        final restModel =
                            (await Database().getPos(widget.orderModel.restId));
                        final restPos = LatLng(restModel.lat, restModel.lng);
                        final driverPos = (await Geolocator()
                            .getCurrentPosition(
                                desiredAccuracy: LocationAccuracy.high));
                        final driverLat =
                            LatLng(driverPos.latitude, driverPos.longitude);

                        routeBloc.getRouteTo(driverLat, restPos, context);
                      },
                      child: Text(
                        "Start",
                        style: tt.button,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        //_askPermission(context, 'PICKED_UP');
                      },
                      child: Text(
                        "Ritirato",
                        style: tt.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 200.0,
            child: GoogleMapsWidget(),
          ),
        ],
      ),
    );
  }
}
