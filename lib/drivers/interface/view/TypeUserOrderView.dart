import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/model/OrderModel.dart';
import 'package:easy_route/easy_route.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/restaurant/update/update.dart';

class TypeOrderView extends StatelessWidget {
  final UserOrderModel model;

  const TypeOrderView({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textButtonTheme = theme.textTheme.title.copyWith(color: Colors.white);
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
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 186,
              minHeight: 48,
            ),
            child: new Container(
              child: new Column(
                children: <Widget>[
                  ListView.builder(
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
                              Text('Data Ordine: ' + model.time+'\nStato Ordine: ' + translateOrderCategory(model.state)),
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
                ],
              ),
              padding: EdgeInsets.all(4.0),
              decoration: new BoxDecoration(
                  border: new Border.all(
                    color: (model.state == 'PENDING')
                        ? Colors.red
                        : Colors.black,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
