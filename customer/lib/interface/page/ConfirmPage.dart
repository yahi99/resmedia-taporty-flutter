import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/CheckoutBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/BottonButtonBar.dart';
import 'package:resmedia_taporty_customer/interface/view/CartProductListView.dart';
import 'package:toast/toast.dart';

class ConfirmPage extends StatefulWidget {
  final SupplierModel supplier;
  final GeoPoint customerCoordinates;
  final String customerAddress;
  final TabController controller;

  ConfirmPage({
    Key key,
    @required this.controller,
    @required this.supplier,
    @required this.customerAddress,
    @required this.customerCoordinates,
  }) : super(key: key);

  @override
  _ConfirmState createState() => _ConfirmState();
}

class _ConfirmState extends State<ConfirmPage> with AutomaticKeepAliveClientMixin {
  final supplierBloc = $Provider.of<SupplierBloc>();
  final cartBloc = $Provider.of<CartBloc>();
  final checkoutBloc = $Provider.of<CheckoutBloc>();

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
                Navigator.pushNamedAndRemoveUntil(context, "/supplierList", (route) => false);
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

  // TODO: Metti un riassunto di tutte le informazioni
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: StreamBuilder<CartModel>(
        stream: cartBloc.outCart,
        builder: (context, cartSnapshot) {
          if (!cartSnapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Scaffold(
            body: CartProductListView(
              cart: cartSnapshot.data,
              modifiable: false,
            ),
            bottomNavigationBar: BottomButtonBar(
              color: Colors.white10,
              child: Container(
                color: theme.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      color: theme.primaryColor,
                      child: Text(
                        "Indietro",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        widget.controller.animateTo(widget.controller.index - 1);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Conferma",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: theme.primaryColor,
                      onPressed: () async {
                        var driverId = await checkoutBloc.findDriver();
                        if (driverId != null) {
                          await checkoutBloc.confirmOrder(driverId);
                          _showPaymentDialog(context);
                        } else {
                          Toast.show('Fattorino non più disponibile nell\'orario selezionato!\nCambia l\'orario e riprova.', context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
