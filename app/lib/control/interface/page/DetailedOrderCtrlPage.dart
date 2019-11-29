import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/DetailedOrderUser.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:toast/toast.dart';

class DetailOrderCtrlPage extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "DetailOrderCtrlPage";

  String get route => DetailOrderCtrlPage.ROUTE;

  final RestaurantOrderModel model;

  DetailOrderCtrlPage({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  _DetailOrderRestaurantPageState createState() =>
      _DetailOrderRestaurantPageState();
}

class _DetailOrderRestaurantPageState extends State<DetailOrderCtrlPage> {
  bool isDeactivate = false;

  List<String> states = [
    'DENIED',
    'CANCELLED',
    'DELIVERED',
    'PENDING',
    'ACCEPTED'
  ];

  String state;

  StreamController stateStream;

  List<DropdownMenuItem> dropType = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    stateStream = new StreamController<String>.broadcast();
    for (int i = 0; i < states.length; i++) {
      dropType.add(DropdownMenuItem(
        child: Text(states[i]),
        value: states[i],
      ));
    }
    state = translateOrderCategory(widget.model.state);
  }

  @override
  void dispose() {
    super.dispose();
    stateStream.close();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cart = Cart(products: widget.model.products);
    return StreamBuilder(
      stream: Database().getCtrlOrder(widget.model.id),
      builder: (ctx,order){
        if(!order.hasData) return Center(child: CircularProgressIndicator(),);
        final model=order.data;
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
                        Row(
                          children: <Widget>[
                            Text('Stato ordine: ', style: tt.subtitle),
                            Text(translateOrderCategory(model.state)),
                            StreamBuilder(
                              stream: stateStream.stream,
                              builder: (ctx, snap) {
                                return Padding(
                                  child: DropdownButton(
                                    //key: _dropKey,
                                    value: (!snap.hasData)
                                        ? states.elementAt(0)
                                        : snap.data,
                                    onChanged: (value) {
                                      print(value);
                                      state = value;
                                      stateStream.add(value);
                                    },
                                    items: dropType,
                                  ),
                                  padding: EdgeInsets.only(bottom: SPACE * 2),
                                );
                              },
                            ),
                            RaisedButton(
                              child: Text('Cambia'),
                              onPressed: () {
                                if (state !=
                                    translateOrderCategory(model.state))
                                  Database()
                                      .updateState(
                                      state,
                                      widget.model.uid,
                                      widget.model.id,
                                      widget.model.restaurantId,
                                      widget.model.driver)
                                      .then((value) {
                                    Toast.show('Stato cambiato', context,
                                        duration: 3);
                                  });
                                else
                                  Toast.show(
                                      'Scegli uno stato diverso da quello corrente',
                                      context,
                                      duration: 3);
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(model.isPaid?'Pagato':'Da Pagare'),
                            model.isPaid?RaisedButton(child: Text('Paga'),onPressed: (){
                              //TODO pay
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
                              }).then((isDone){
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
                              });
                            },):RaisedButton(child:Text('Rimborsa'),onPressed: (){
                              //TODO rimborso
                            },),
                          ],
                        ),
                        Text('Inidirizzo cliente: ', style: tt.subtitle),
                        Text(widget.model.addressR),
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
      },
    );
  }
}
