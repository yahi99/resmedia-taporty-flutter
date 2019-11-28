import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';

class DetailedOrderUser extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "DetailedOrderUser";

  String get route => DetailedOrderUser.ROUTE;

  final UserOrderModel model;

  DetailedOrderUser({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  _DetailOrderRestaurantPageState createState() =>
      _DetailOrderRestaurantPageState();
}

class _DetailOrderRestaurantPageState extends State<DetailedOrderUser> {
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
    final cart = Cart(products: widget.model.products);
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
                    Text('Prodotti: ', style: tt.subtitle),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: cart.products.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return ProductView(model:cart.products.elementAt(index),number:cart.products
                                  .elementAt(index)
                                  .countProducts);
                        }),
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

class ProductView extends StatelessWidget {
  final ProductCart model;
  final int number;
  //final StreamController<String> imgStream=new StreamController.broadcast();

  ProductView(
      {Key key,
        @required this.model,@required this.number})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //if(model.number!=null) downloadFile(model.img);

    TextEditingController ctrl=new TextEditingController();
    return DefaultTextStyle(
      style: theme.textTheme.body1,
      child: SizedBox(
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        '${model.id.substring(0, (15 < model.id.length) ? 15 : model.id.length)}'),
                    Text('€ ${model.price}'),
                  ],
                ),
              ],
            ),
            Container(
              child:TextFormField(
                enabled: false,
                initialValue: number.toString(),
              ),
              width: MediaQuery.of(context).size.width/5,
            ),
          ],
        ),
      ),
    );
  }
}