import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';

class TypeOrderView extends StatefulWidget implements WidgetRoute {
static const String ROUTE = "TypeOrderView";

String get route => ROUTE;

final UserOrderModel model;

const TypeOrderView({
  Key key,
  this.model,
}) : super(key: key);

@override
_LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<TypeOrderView> {

  List<String> points = [
    '1',
    '2',
    '3',
    '4',
    '5'
  ];

  String pointF,pointR;

  StreamController pointStreamF;
  StreamController pointStreamR;

  final _restKey = new GlobalKey<FormFieldState>();
  final _driverKey = new GlobalKey<FormFieldState>();

  List<DropdownMenuItem> dropPoint = List<DropdownMenuItem>();

  @override
  void initState(){
    super.initState();
    pointStreamF=new StreamController<String>.broadcast();
    pointStreamR=new StreamController<String>.broadcast();
    for(int i=0;i<points.length;i++){
      dropPoint.add(DropdownMenuItem(
        child: Text(points[i]),
        value: points[i],
      ));
    }
    pointF=points[points.length-1];
    pointR=points[points.length-1];
  }

  @override
  void dispose() {
    super.dispose();
    pointStreamF.close();
    pointStreamR.close();
  }

  String toDate(String date){
    final DateTime dateTime=DateTime.parse(date);
    return(dateTime.day.toString()+'/'+dateTime.month.toString()+'/'+dateTime.year.toString());
  }


  void _addReview(BuildContext context) {
    showDialog(
        context: context,
        builder: (_context) {
          final theme = Theme.of(context);
          final cls = theme.colorScheme;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
              child:
              ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Valutazione Ristorante'),
                      StreamBuilder(
                        stream: pointStreamR.stream,
                        builder: (ctx,snap){
                          return Padding(
                            child:DropdownButton(
                              //key: _dropKey,
                              value: (!snap.hasData)
                                  ? pointR
                                  : snap.data,
                              onChanged: (value) {
                                print(value);
                                pointR = value;
                                pointStreamR.add(value);
                              },
                              items: dropPoint,
                            ),
                            padding: EdgeInsets.only(bottom: SPACE * 2),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    child: TextFormField(
                      key: _restKey,
                      textInputAction: TextInputAction.done,
                      validator: (value){
                        if(value.length==0){
                          return 'Inserisci valutazione';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Come è stata la tua esperienza?",
                      ),
                      maxLines: 10,
                      minLines: 5,
                      keyboardType: TextInputType.text,
                    ),
                    padding: EdgeInsets.all(8.0),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Valutazione Fattorino'),
                      StreamBuilder(
                        stream: pointStreamF.stream,
                        builder: (ctx,snap){
                          return Padding(
                            child:DropdownButton(
                              //key: _dropKey,
                              value: (!snap.hasData)
                                  ? pointF
                                  : snap.data,
                              onChanged: (value) {
                                print(value);
                                pointF = value;
                                pointStreamF.add(value);
                              },
                              items: dropPoint,
                            ),
                            padding: EdgeInsets.only(bottom: SPACE * 2),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    child: TextFormField(
                      key: _driverKey,
                      textInputAction: TextInputAction.done,
                      validator: (value){
                        if(value.length==0){
                          return 'Inserisci valutazione';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Come è stata la tua esperienza?",
                      ),
                      maxLines: 10,
                      minLines: 5,
                      keyboardType: TextInputType.text,
                    ),
                    padding: EdgeInsets.all(8.0),
                  ),
                  RaisedButton(
                    child: Text('Invia la recensione'),
                    onPressed: ()async{
                      if(_driverKey.currentState.validate() && _restKey.currentState.validate()){
                        Database().pushReviewRest(widget.model.restaurantId, int.parse(pointR), _restKey.currentState.value);
                        Database().pushReviewDriver(widget.model.driver, int.parse(pointF), _driverKey.currentState.value);
                        Database().setReviewed((await UserBloc.of().outUser.first).model.id, widget.model.id);
                      }
                    },
                  )
                ],
              ),
              height: 400,
              width: 200,
            ),
          );
        }
    );
  }

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
    final cart = Cart(products: widget.model.products);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 186,
              minHeight: 48,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Prodotti: ', style: theme.textTheme.subtitle),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cart.products.length + 2,
                      itemBuilder: (BuildContext ctx, int index) {
                        if (index == cart.products.length)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Prezzo totale: ',
                                  style: theme.textTheme.subtitle),
                              Text(cart
                                      .getTotalPrice(
                                          cart.products,
                                          cart.products.first.userId,
                                          cart.products.first.restaurantId)
                                      .toString() +
                                  ' euro'),
                            ],
                          );
                        else if (index == cart.products.length + 1)
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Data Ordine: ',
                                  style: theme.textTheme.subtitle),
                              Text(widget.model.timeR),
                              Text('Data ed ora consegna: '),
                              Text(toDate(widget.model.day)+' alle ore '+widget.model.endTime),
                              Text('Stato Ordine: ',
                                  style: theme.textTheme.subtitle),
                              Text(translateOrderCategory(widget.model.state)),
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
                  (translateOrderCategory(widget.model.state)=='DELIVERED' && !widget.model.isReviewed)?RaisedButton(
                    child: Text('Lascia una Recensione'),
                    onPressed: (){
                      _addReview(context);
                    },
                  ):Container(),
                ],
              ),
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  border: Border.all(
                color: (translateOrderCategory(widget.model.state) == 'In Consegna')
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
