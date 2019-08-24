import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/drivers/interface/tab/OrdersTab.dart';
import 'package:mobile_app/drivers/interface/widget/GoogleMapsUI.dart';
import 'package:mobile_app/drivers/model/SubjectModel.dart';


class SubjectOrderPageDriver extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "SubjectOrderPageDriver";
  String get route => SubjectOrderPageDriver.ROUTE;

  final SubjectModel model;

  SubjectOrderPageDriver({Key key, @required this.model}) : super(key: key);

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


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cls = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RubberConcierge(),
      ),
      body: ListViewSeparated(
        controller: RubberScrollController.of(context),
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(SPACE),
        separator: const SizedBox(height: 8.0,),
        children: <Widget>[
          Text("", style: tt.title,),
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
                          Text(widget.model.title, style: tt.subtitle,),
                          Text(widget.model.address, style: tt.subhead,),
                          Text("${widget.model.time}", style: tt.subhead,),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          color: cls.secondaryVariant,
                          onPressed: () {},
                          child: Text("Chiama", style: tt.button,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Tempo di arrivo stimato", style: tt.subtitle,),
                    Text(widget.model.address, style: tt.subhead,),
                    Text("${widget.model.time}", style: tt.subhead,),
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
                      onPressed: () {},
                      child: Text("Start", style: tt.button,),
                    ),
                  ),
                  SizedBox(width: 16.0,),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text("Ritirato", style: tt.button,),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

