import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/drivers/model/CalendarModel.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:mobile_app/model/OrderModel.dart';
import 'package:easy_route/easy_route.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/restaurant/page/DetailOrderRestaurantPage.dart';
import 'package:mobile_app/restaurant/update/update.dart';

class TypeOrderView extends StatelessWidget {
  final RestaurantOrderModel model;

  const TypeOrderView({
    Key key,
    this.model,
  }) : super(key: key);

  int totalProducts(List<ProductCart> cart){
    int sum=0;
    for(int i=0;i<cart.length;i++){
      sum+=cart.elementAt(i).countProducts;
    }
    return sum;
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
    final cart = new Cart(products: model.products);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: (){
            EasyRouter.push(context,DetailOrderRestaurantPage(model:model));
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 186,
              minHeight: 48,
            ),
            child: new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Wrap(
              runSpacing: 16.0,
                children: <Widget>[
                  Text('Cliente: ',style:tt.subtitle),
                  Text(model.nominative),
                  Text('Ora di consegna: ',style:tt.subtitle),
    Text(model.endTime),
                  Text('Numero di prodotti: ',style:tt.subtitle),
    Text(totalProducts(model.products).toString()),
                  Text('Prezzo totale: ',style:tt.subtitle),
                      Text(
                      cart
                          .getTotalPrice(
                              cart.products,
                              cart.products.first.userId,
                              cart.products.first.restaurantId)
                          .toString() +
                      ' euro'),
                  Text('Stato dell\'ordine: ',style:tt.subtitle),
    Text(translateOrderCategory(model.state)),
                  Center(
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        color: theme.colorScheme.secondaryVariant,
                        onPressed: () {},
                        child: Text("Chiama", style: tt.button,),
                      ),
                  ),
                  ),
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
                      ? new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new RaisedButton(
                              child: Text('Accetta'),
                              onPressed: () =>{
                                CloudFunctions.instance.getHttpsCallable(functionName: 'updateState').call({'state':'ACCEPTED',
                                  'oid':model.id,'rid':model.products.first.restaurantId,'timeS':DateTime.now()
                                ,'did':model.driver,'uid':model.uid})
                              },
                              color: Colors.green,
                            ),
                            new RaisedButton(
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
              decoration: new BoxDecoration(
                  border: new Border.all(
                color: (translateOrderCategory(model.state) == 'In Accettazione') ? Colors.red : Colors.black,
              )),
            ),
          ),
        ),
      ],
    );
  }
}
