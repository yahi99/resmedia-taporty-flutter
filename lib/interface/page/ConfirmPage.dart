import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/interface/page/CartPage.dart';
import 'package:mobile_app/interface/screen/CheckoutScreen.dart';
import 'package:mobile_app/interface/screen/RestaurantScreen.dart';
import 'package:mobile_app/interface/view/BottonButtonBar.dart';
import 'package:mobile_app/logic/bloc/CartBloc.dart';
import 'package:mobile_app/logic/bloc/RestaurantBloc.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/model/ProductModel.dart';
import 'package:mobile_app/model/RestaurantModel.dart';
import 'package:toast/toast.dart';


class ConfirmPage extends StatefulWidget {
  final RestaurantModel model;
  final Position position;
  final Address description;

  ConfirmPage({Key key, @required this.model,
  @required this.description,@required this.position}) : super(key: key);

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<ConfirmPage>with AutomaticKeepAliveClientMixin {

  _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        final cls = theme.colorScheme;
        return AlertDialog(
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cls.secondary,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              Text(
                "Il tuo ordine verrà processato entro 15 minuti!",
                style: theme.textTheme.body2,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                EasyRouter.popUntil(context,RestaurantScreen.ROUTE);
              },
              textColor: cls.secondary,
              child: Text(
                "Chiudi",
              ),
            )
          ],
        );
      },
    );
  }

  bool valid(BuildContext context){
    final state=MyInheritedWidget.of(context);
    print(state.time);
    if(state.name==null || state.email==null || state.address==null || state.phone==null || state.cap==null || state.date==null || state.time==null)
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final tt=Theme.of(context);
    final restaurantBloc = RestaurantBloc.init(idRestaurant: widget.model.id);
    final cartBloc = CartBloc.of();
    //cartBloc.setSigner(model.id);
    final user = UserBloc.of();
    return StreamBuilder<FirebaseUser>(
      stream: user.outFirebaseUser,
      builder: (ctx, uid) {
        return Scaffold(
          body: StreamBuilder<List<DrinkModel>>(
            stream: restaurantBloc.outDrinks,
            builder: (context, snapshot) {
              return StreamBuilder<List<FoodModel>>(
                stream: restaurantBloc.outFoods,
                builder: (context, snap) {
                  if(RestaurantScreen.isOrdered) {
                    RestaurantScreen.isOrdered=false;
                    Future.delayed(
                        Duration.zero, () => _showPaymentDialog(context));
                  }
                  if (!snapshot.hasData || !snap.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return ProductsFoodDrinkBuilder(
                    drinks: snapshot.data,
                    foods: snap.data,
                    id: widget.model.id,
                  );
                },
              );
            },
          ),
          bottomNavigationBar: BottomButtonBar(
            color: Colors.white10,
            child:new Container(
                  color: tt.primaryColor,
                  child:FlatButton(
                    child: Text(
                      "Continua",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: tt.primaryColor,
                    onPressed: () {
                      if(valid(context)) {
                        final state = MyInheritedWidget.of(context);
                        cartBloc.isAvailable(state.date, state.time).then((user){
                          if(user!=null){
                            cartBloc.signer(widget.model.id,user,widget.position,widget.description.addressLine,state.time).then((isDone) {
                              RestaurantScreen.isOrdered=false;
                              Future.delayed(
                                  Duration.zero, () => _showPaymentDialog(context));
                              print('ok');
                            }).catchError((error) {
                              print(error.toString());
                            });
                          }
                          else{
                            Toast.show('Fattorino non più disponibile nell\'orario selezionato!\nCambia l\'orario e riprova.', context);
                          }
                        });

                      }
                      else{
                        Toast.show('Mancano dei dati.', context);
                      }
                    },
                  ),
                ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
