import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_flutter/control/interface/page/DetailedOrderCtrlPage.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/DetailOrderRestaurantPage.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class TypeCtrlOrderView extends StatelessWidget {
  final RestaurantOrderModel model;

  const TypeCtrlOrderView({
    Key key,
    this.model,
  }) : super(key: key);

  int totalProducts(List<ProductCart> cart) {
    int sum = 0;
    for (int i = 0; i < cart.length; i++) {
      sum += cart.elementAt(i).countProducts;
    }
    return sum;
  }

  _showPositionDialog(BuildContext context) {
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
                  Text(
                    "Sicuro di volere cancellare questo ordine?",
                    style: theme.textTheme.body2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          EasyRouter.pop(context);
                        },
                        textColor: Colors.white,
                        color: Colors.red,
                        child: Text(
                          "Nega",
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Database().deleteOrderFinal(model).then((value) {
                            Toast.show('Ordine cancellato', context);
                            EasyRouter.pop(context);
                          });
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Consenti",
                        ),
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

  String toDate(String date){
    final DateTime dateTime=DateTime.parse(date);
    return(dateTime.day.toString()+'/'+dateTime.month.toString()+'/'+dateTime.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var tt = theme.textTheme;
    /*final _restaurantsBloc = RestaurantsBloc.instance(model.id);
    return CacheStreamBuilder<List<RestaurantModel>>(
        stream: _restaurantsBloc.outRestaurants,
        builder: (context, snap) {
          return Stack(
              alignment: Alignment.center,
              children: snap.data.map<Widget>((_model) {
                AspectRatio(
                  aspectRatio: 2,
                  child: Image.asset(_model.img, fit: BoxFit.fill,),
                );
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 186,
                      minHeight: 48,
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        EasyRouter.push(context,
                          RestaurantListScreen(
                            title: _model.title, models: _model,),);
                      },
                      child: Text(_model.title, style: textButtonTheme,),
                    ),
                  ),

                );
              }
              ),
          );
        }
    );*/
    final cart = Cart(products: model.products);
    final temp=model.endTime.split(':');
    final day=DateTime.parse(model.day);
    final time=DateTime(day.year,day.month,day.day,int.parse(temp.elementAt(0)),int.parse(temp.elementAt(1)));
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.blue,
          icon: Icons.close,
          onTap: () async {
            _showPositionDialog(context);
          },
        ),
      ],
        child:Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            EasyRouter.push(context, DetailOrderCtrlPage(model: model));
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 186,
              minHeight: 48,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    runSpacing: 16.0,
                    children: <Widget>[
                      Text('Cliente: ', style: tt.subtitle),
                      Text(model.nominative),
                      Text('Ristorante: ', style: tt.subtitle),
                      Text(model.products.first.restaurantId),
                      Text('Giorno di consegna: ', style: tt.subtitle),
                      Text(toDate(model.day)),
                      Text('Ora di consegna: ', style: tt.subtitle),
                      Text(model.endTime),
                      Text('Prezzo totale: ', style: tt.subtitle),
                      Text(cart
                          .getTotalPrice(
                          cart.products,
                          cart.products.first.userId,
                          cart.products.first.restaurantId)
                          .toString() +
                          ' euro'),
                      Text('Stato dell\'ordine: ', style: tt.subtitle),
                      Text(translateOrderCategory(model.state)),
                    ],
                  ),
                  /*ListView.builder(
                      shrinkWrap: true,
                      itemCount: cart.products.length + 2,
                      itemBuilder: (BuildContext ctx, int index) {
                        if (index == cart.products.length)
                          return Text('Prezzo totale: ' +
                              cart
                                  .getTotalPrice(
                                      cart.products,
                                      cart.products.first.userId,
                                      cart.products.first.restaurantId)
                                  .toString() +
                              ' euro');
                        else if (index == cart.products.length + 1)
                          return Column(
                            children: <Widget>[
                              Text('Data Ordine: ' + model.timeR+'\nStato Ordine: ' + translateOrderCategory(model.state)),
                            ],
                          );
                        else {
                          return Text(cart.products.elementAt(index).id +
                              ' x' +
                              cart.products
                                  .elementAt(index)
                                  .countProducts
                                  .toString());
                        }
                      }),
                  (model.state == 'PENDING')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              child: Text('Accetta'),
                              onPressed: () =>{
                                CloudFunctions.instance.getHttpsCallable(functionName: 'updateState').call({'state':'ACCEPTED',
                                  'oid':model.id,'rid':model.products.first.restaurantId,'timeS':DateTime.now()
                                ,'did':model.driver,'uid':model.uid})
                              },
                              color: Colors.green,
                            ),
                            RaisedButton(
                              child: Text('Rifiuta'),
                              onPressed: () async{
                                DateTime temp=DateTime.tryParse(model.timeR);
                                DateTime time=DateTime(temp.year,temp.month,temp.minute);
                                String user=(await UserBloc.of().outUser.first).model.id;
                                Database().getDriverCalModel(user, time.toIso8601String(), model.startTime).then((cal){
                                  final occ=cal.occupied;
                                  occ.remove(user);
                                  final lib=cal.free;
                                  lib.add(user);
                                  CloudFunctions.instance.getHttpsCallable(functionName: 'updateState').call({'state':'DENIED','oid':model.id,
                                    'rid':model.products.first.restaurantId,'free':lib,'occupied':occ,'isEmpty':false
                                    ,'day':time.toIso8601String(),'startTime':cal.startTime,'did':model.driver,'uid':model.uid
                                  ,'timeS':DateTime.now()});
                                });

                              },
                              color: Colors.red,
                            ),
                          ],
                        )
                      : Container(),
                      */
                ],
              ),
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    (time.difference(DateTime.now()).inMinutes>0 && time.difference(DateTime.now()).inMinutes <=45)
                        ? Colors.red
                        : Colors.black,
                  )),
            ),
          ),
        ),
      ],
        ),
    );
  }
}
