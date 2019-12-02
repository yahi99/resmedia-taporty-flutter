import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';

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
    final cart = Cart(products: widget.model.products);
    return StreamBuilder<RestaurantOrderModel>(
      stream: Database().getRestaurantOrder(widget.model.restaurantId, widget.model.id),
      builder: (ctx,order){
        if(!order.hasData) return Center(child: CircularProgressIndicator(),);
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
                        ListView.separated(
                            shrinkWrap: true,
                            itemCount: cart.products.length,
                            separatorBuilder: (ctx,index){
                              return Divider(height: 4.0,);
                            },
                            itemBuilder: (BuildContext ctx, int index) {
                              return ProductView(model:cart.products.elementAt(index),number:cart.products
                                  .elementAt(index)
                                  .countProducts);
                            }),
                        (translateOrderCategory(order.data.state) ==
                            'In Accettazione')
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              child: Text('Accetta'),
                              onPressed: () {
                                List <String> foodIds=new List<String>();
                                List <String> drinkIds=new List<String>();
                                for(int i=0;i<widget.model.products.length;i++){
                                  if(widget.model.products.elementAt(i).category=='foods'){
                                    for(int j=0;j<widget.model.products.elementAt(i).countProducts;j++) foodIds.add(widget.model.products.elementAt(i).id);
                                  }
                                  else{
                                    for(int j=0;j<widget.model.products.elementAt(i).countProducts;j++) drinkIds.add(widget.model.products.elementAt(i).id);
                                  }
                                }
                                CloudFunctions.instance.getHttpsCallable(functionName: 'createStripeCharge').call({
                                  'foodIds':foodIds,
                                  'drinkIds':drinkIds,
                                  'restaurantId':widget.model.products.first.restaurantId,
                                  'uid':widget.model.uid,
                                  'oid':widget.model.id
                                }).then((isDone)async{
                                  Database().updateBank(widget.model,cart.getTotalPrice(cart.products, widget.model.uid, widget.model.restaurantId));
                                  CloudFunctions.instance
                                      .getHttpsCallable(
                                      functionName: 'updateState')
                                      .call({
                                    'state': 'ACCEPTED',
                                    'oid': widget.model.id,
                                    'rid': widget
                                        .model.products.first.restaurantId,
                                    'timeS': DateTime.now().toIso8601String(),
                                    'did': widget.model.driver,
                                    'uid': widget.model.uid
                                  });
                                  EasyRouter.pop(context);
                                });
                              },
                              color: Colors.green,
                            ),
                            RaisedButton(
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
                                    'timeS': DateTime.now().toIso8601String()
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
      },
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
                    Flexible(child:Container(child: Text(model.id),width: MediaQuery.of(context).size.width*3/5),),
                    /*Text(
                        '${model.id.substring(0, (15 < model.id.length) ? 15 : model.id.length)}'),

                     */
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