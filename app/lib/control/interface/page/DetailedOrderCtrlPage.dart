import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
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
    'ACCEPTED',
    'PICKED_UP'
  ];

  String state,driverN,driverId;

  UserModel driverModel;

  StreamController stateStream,driversStream;

  List<DropdownMenuItem> dropType = List<DropdownMenuItem>();

  //TODO ADD TURN FOR THE DRIVER MAYBE?
  Future<String> isAvailable(String date, String time,String restId,UserModel driver) async {
    final model = await Database().getUsers(date, time);
      final temp = model.free;
      temp.remove(driver.id);
      final occ = model.occupied;
      occ.add(driver.id);
      await Database().occupyDriver(date, time, temp, occ,restId,driver.id);
      return 'ok';
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
                    "Sicuro di volere assegnare "+driverModel.id+" all'ordine?",
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
                          isAvailable(widget.model.day, widget.model.startTime, widget.model.restaurantId,driverModel);
                          Database().updateOrderDriver(widget.model, driverModel.id).then((value) {
                            Toast.show('Fattorino assegnato', context);
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

  @override
  void initState() {
    super.initState();
    stateStream = new StreamController<String>.broadcast();
    driversStream= new StreamController<UserModel>.broadcast();
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
    driversStream.close();
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
          body: Container(
          child:ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(SPACE),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                        Text(
                          "DETTAGLIO ORDINE",
                          style: tt.title,
                        ),
                        SizedBox(height: 16.0,),
                        Text('Assegna ordine al fattorino', style: tt.subtitle),
                        SizedBox(height: 16.0,),
                        Row(
                          children: <Widget>[
                            StreamBuilder<List<UserModel>>(
                              stream: Database().driversList(),
                              builder: (ctx,drivers){
                                if(drivers.hasData){
                                  List<DropdownMenuItem> dropDrivers = List<DropdownMenuItem>();
                                  for (int i = 0; i < drivers.data.length; i++) {
                                    dropDrivers.add(DropdownMenuItem(
                                      child: Text(drivers.data[i].id.substring(0,10)+'...'),
                                      value: drivers.data[i],
                                    ));
                                  }
                                  driverModel=drivers.data[0];
                                  driverN=drivers.data[0].nominative;
                                  driverId=drivers.data[0].id;
                                  return StreamBuilder<UserModel>(
                                    stream: driversStream.stream,
                                    builder: (ctx,driver){
                                      return Padding(
                                        child: DropdownButton(
                                          //key: _dropKey,
                                          value: (!driver.hasData)
                                              ? driverModel
                                              : driver.data,
                                          onChanged: (value) {
                                            print(value.id);
                                            driverModel=value;
                                            driverN = value.nominative;
                                            driverId=value.id;
                                            driversStream.add(value);
                                          },
                                          items: dropDrivers,
                                        ),
                                        padding: EdgeInsets.only(right: SPACE * 2),
                                      );
                                    },
                                  );
                                }
                                else return Text('Non ci sono fattorini.');
                              },
                            ),
                            RaisedButton(
                              child: Text('Assegna'),
                              onPressed: (){
                                _showPositionDialog(context);
                              },
                            )
                          ],
                        ),
                    SizedBox(height: 16.0,),
                        Text('Stato ordine: ', style: tt.subtitle),
                    SizedBox(height: 16.0,),
                        Text(translateOrderCategory(model.state)),
                    SizedBox(height: 16.0,),
                        Row(
                          children: <Widget>[
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
                                  padding: EdgeInsets.only(right: SPACE * 2),
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
                    SizedBox(height: 16.0,),
                        Row(
                          children: <Widget>[
                            Text(model.isPaid?'Pagato':'Da Pagare'),
                            !model.isPaid?RaisedButton(child: Text('Paga'),onPressed: (){
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
                              CloudFunctions.instance.getHttpsCallable(functionName: 'reimbursCharge').call({
                              'fingerprint':widget.model.fingerprint
                              }).then((isDone){

                              });
                            },),
                          ],
                        ),
                    SizedBox(height: 16.0,),
                        Text('Inidirizzo cliente: ', style: tt.subtitle),
                    SizedBox(height: 16.0,),
                        Text(widget.model.addressR),
                        /*
                        Text('Prodotti: ', style: tt.subtitle),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: cart.products.length,
                            itemBuilder: (BuildContext ctx, int index) {
                              return ProductView(model:cart.products.elementAt(index),number:cart.products
                                      .elementAt(index)
                                      .countProducts);
                            }),

                         */
                      ],
                    ),
              ),
            ],
          ),
            height: MediaQuery.of(context).size.height*4/5,
          ),
        );
      },
    );
  }
}
