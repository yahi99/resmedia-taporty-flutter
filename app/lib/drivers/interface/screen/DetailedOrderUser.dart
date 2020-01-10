import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

class DetailedOrderUser extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "DetailedOrderUser";

  String get route => DetailedOrderUser.ROUTE;

  final OrderModel order;

  DetailedOrderUser({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  _DetailOrderRestaurantPageState createState() => _DetailOrderRestaurantPageState();
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
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Wrap(
                    runSpacing: 16.0,
                    children: <Widget>[
                      Text('Prodotti: ', style: tt.subtitle),
                      if (widget.order.products != null)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.order.products.length,
                          separatorBuilder: (ctx, index) {
                            return Divider(
                              height: 4.0,
                            );
                          },
                          itemBuilder: (BuildContext ctx, int index) {
                            return ProductView(model: widget.order.products[index], number: widget.order.products[index].quantity);
                          },
                        ),
                      if (widget.order.products == null || widget.order.products.length == 0) Text("Nessun prodotto nel carrello")
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductView extends StatelessWidget {
  final OrderProductModel model;
  final int number;
  //final StreamController<String> imgStream=new StreamController.broadcast();

  ProductView({Key key, @required this.model, @required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //if(model.number!=null) downloadFile(model.img);

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
                    Text('${model.name}'),
                    Text('€ ${model.price.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
            Container(
              child: TextFormField(
                enabled: false,
                initialValue: number.toString(),
              ),
              width: MediaQuery.of(context).size.width / 5,
            ),
          ],
        ),
      ),
    );
  }
}
