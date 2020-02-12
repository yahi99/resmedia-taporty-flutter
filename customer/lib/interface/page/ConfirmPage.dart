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
    return StreamBuilder<bool>(
      stream: checkoutBloc.outConfirmLoading,
      builder: (context, loadingSnap) {
        bool isLoading = loadingSnap.data ?? false;
        return StreamBuilder<CartModel>(
          stream: cartBloc.outCart,
          builder: (context, cartSnapshot) {
            if (!cartSnapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Scaffold(
              body: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : CartProductListView(
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
                        ),
                        textColor: Colors.white,
                        disabledTextColor: Colors.white54,
                        onPressed: isLoading
                            ? null
                            : () {
                                widget.controller.animateTo(widget.controller.index - 1);
                              },
                      ),
                      FlatButton(
                        child: Text(
                          "Conferma",
                        ),
                        textColor: Colors.white,
                        disabledTextColor: Colors.white54,
                        color: theme.primaryColor,
                        onPressed: isLoading
                            ? null
                            : () async {
                                try {
                                  await checkoutBloc.processOrder();
                                  _showPaymentDialog(context);
                                } on NoAvailableDriverException {
                                  Toast.show('Fattorino non più disponibile nell\'orario selezionato!\nCambia l\'orario e riprova.', context);
                                } on PaymentIntentException catch (err) {
                                  Toast.show(err.message, context);
                                } catch (err) {
                                  print(err);
                                  Toast.show('Errore sconosciuto!', context);
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
