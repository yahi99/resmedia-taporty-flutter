import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:mobile_app/model/OrderModel.dart';

class DetailOrderRestaurantPage extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "DetailOrderPageDriver";

  String get route => DetailOrderRestaurantPage.ROUTE;

  final RestaurantOrderModel model;

  DetailOrderRestaurantPage({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  _DetailOrderRestaurantPageState createState() =>
      _DetailOrderRestaurantPageState();
}

class _DetailOrderRestaurantPageState extends State<DetailOrderRestaurantPage> {
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
    final cart = new Cart(products: widget.model.products);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(SPACE),
            child: Column(
              children: <Widget>[
                Wrap(
                  runSpacing: 16.0,
                  children: <Widget>[
                    Text(
                      "DETTAGLIO ORDINE",
                      style: tt.title,
                    ),
                    Text('Inidirizzo cliente: ', style: tt.subtitle),
                    Text(widget.model.addressR),
                    Text('Prodotti: ', style: tt.subtitle),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: cart.products.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return Text(cart.products.elementAt(index).id +
                              ' x' +
                              cart.products
                                  .elementAt(index)
                                  .countProducts
                                  .toString());
                        }),
                    (translateOrderCategory(widget.model.state) ==
                            'In Accettazione')
                        ? new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new RaisedButton(
                                child: Text('Accetta'),
                                onPressed: () => {
                                  CloudFunctions.instance
                                      .getHttpsCallable(
                                          functionName: 'updateState')
                                      .call({
                                    'state': 'ACCEPTED',
                                    'oid': widget.model.id,
                                    'rid': widget
                                        .model.products.first.restaurantId,
                                    'timeS': DateTime.now(),
                                    'did': widget.model.driver,
                                    'uid': widget.model.uid
                                  })
                                },
                                color: Colors.green,
                              ),
                              new RaisedButton(
                                child: Text('Rifiuta'),
                                onPressed: () async {
                                  DateTime temp =
                                      DateTime.tryParse(widget.model.timeR);
                                  DateTime time = DateTime(
                                      temp.year, temp.month, temp.minute);
                                  String user =
                                      (await UserBloc.of().outUser.first)
                                          .model
                                          .id;
                                  Database()
                                      .getDriverCalModel(
                                          user,
                                          time.toIso8601String(),
                                          widget.model.startTime)
                                      .then((cal) {
                                    final occ = cal.occupied;
                                    occ.remove(user);
                                    final lib = cal.free;
                                    lib.add(user);
                                    CloudFunctions.instance
                                        .getHttpsCallable(
                                            functionName: 'updateState')
                                        .call({
                                      'state': 'DENIED',
                                      'oid': widget.model.id,
                                      'rid': widget
                                          .model.products.first.restaurantId,
                                      'free': lib,
                                      'occupied': occ,
                                      'isEmpty': false,
                                      'day': time.toIso8601String(),
                                      'startTime': cal.startTime,
                                      'did': widget.model.driver,
                                      'uid': widget.model.uid,
                                      'timeS': DateTime.now()
                                    });
                                  });
                                },
                                color: Colors.red,
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
