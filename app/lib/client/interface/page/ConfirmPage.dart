import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/CartPage.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/BottonButtonBar.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:toast/toast.dart';

class ConfirmPage extends StatefulWidget {
  final RestaurantModel restaurant;
  final GeoPoint customerCoordinates;
  final String customerAddress;
  final TabController controller;

  ConfirmPage({
    Key key,
    @required this.restaurant,
    @required this.customerAddress,
    @required this.customerCoordinates,
    @required this.controller,
  }) : super(key: key);

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<ConfirmPage> with AutomaticKeepAliveClientMixin {
  _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        final cls = theme.colorScheme;
        return AlertDialog(
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 12.0 * 2,
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
                EasyRouter.popUntil(context, RestaurantScreen.ROUTE);
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

  bool valid(BuildContext context) {
    final state = CheckoutScreenInheritedWidget.of(context);
    if (state.name == null || state.email == null || state.phone == null || state.selectedShift == null || state.customerId == null || state.cardId == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tt = Theme.of(context);
    final restaurantBloc = RestaurantBloc.init(restaurantId: widget.restaurant.id);
    final cartBloc = CartBloc.of();
    final user = UserBloc.of();
    return StreamBuilder<FirebaseUser>(
      stream: user.outFirebaseUser,
      builder: (ctx, uid) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                widget.controller.animateTo(widget.controller.index - 1);
              },
            ),
          ),
          body: StreamBuilder<List<ProductModel>>(
            stream: restaurantBloc.outProducts,
            builder: (context, AsyncSnapshot<List<ProductModel>> productListSnapshot) {
              if (!productListSnapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return ProductsFoodDrinkBuilder(
                products: productListSnapshot.data,
                id: widget.restaurant.id,
              );
            },
          ),
          bottomNavigationBar: BottomButtonBar(
            color: Colors.white10,
            child: Container(
              color: tt.primaryColor,
              child: FlatButton(
                child: Text(
                  "Continua",
                  style: TextStyle(color: Colors.white),
                ),
                color: tt.primaryColor,
                onPressed: () async {
                  if (valid(context)) {
                    final state = CheckoutScreenInheritedWidget.of(context);
                    var driverId = await cartBloc.findDriver(state.selectedShift, widget.restaurant.id, widget.customerCoordinates);
                    if (driverId != null) {
                      await cartBloc.signer(widget.restaurant.id, driverId, widget.customerCoordinates, widget.customerAddress, state);
                      _showPaymentDialog(context);
                    } else {
                      Toast.show('Fattorino non più disponibile nell\'orario selezionato!\nCambia l\'orario e riprova.', context);
                    }
                  } else {
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
  bool get wantKeepAlive => true;
}
