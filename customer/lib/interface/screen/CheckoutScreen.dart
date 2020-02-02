import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CheckoutBloc.dart';
import 'package:resmedia_taporty_customer/blocs/LocationBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/page/CartPage.dart';
import 'package:resmedia_taporty_customer/interface/page/ConfirmPage.dart';
import 'package:resmedia_taporty_customer/interface/page/PaymentPage.dart';
import 'package:resmedia_taporty_customer/interface/page/ShippingPage.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';

class CheckoutScreen extends StatefulWidget {
  CheckoutScreen({Key key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> with TickerProviderStateMixin {
  static TabController controller;
  var supplierBloc = $Provider.of<SupplierBloc>();
  var userBloc = $Provider.of<UserBloc>();
  var locationBloc = $Provider.of<LocationBloc>();
  var checkoutBloc = $Provider.of<CheckoutBloc>();

  @override
  void initState() {
    controller = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (controller.index > 0) {
          controller.animateTo(controller.index - 1);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Checkout',
            style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
          ),
          backgroundColor: ColorTheme.RED,
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, "/account");
              },
            )
          ],
          bottom: IgnorePointerTabBarWrapper(
            child: TabBar(
              controller: controller,
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.account_circle,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.credit_card,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.flag,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              border: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 4.0),
                borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
              ),
            ),
          ),
          child: StreamBuilder<UserModel>(
            stream: userBloc.outUser,
            builder: (_, userSnapshot) {
              return StreamBuilder<SupplierModel>(
                stream: supplierBloc.outSupplier,
                builder: (_, supplierSnapshot) {
                  return StreamBuilder<LocationModel>(
                    stream: locationBloc.outCustomerLocation,
                    builder: (_, locationSnapshot) {
                      if (userSnapshot.hasData && supplierSnapshot.hasData && locationSnapshot.hasData) {
                        var user = userSnapshot.data;
                        var supplier = supplierSnapshot.data;
                        var location = locationSnapshot.data;
                        if (supplierSnapshot.data.isDisabled != null && supplierSnapshot.data.isDisabled) {
                          return Padding(
                            child: Text('Fornitore non abilitato scegline un\'altro'),
                            padding: EdgeInsets.all(8.0),
                          );
                        }
                        return TabBarView(
                          controller: controller,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            CartPage(
                              controller: controller,
                              supplier: supplier,
                            ),
                            ShippingPage(
                              controller: controller,
                              user: user,
                              customerCoordinates: location.coordinates,
                              supplier: supplier,
                            ),
                            PaymentPage(
                              controller,
                            ),
                            ConfirmPage(
                              controller: controller,
                              supplier: supplier,
                              customerCoordinates: location.coordinates,
                              customerAddress: location.address,
                            ),
                          ],
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class IgnorePointerTabBarWrapper extends StatelessWidget implements PreferredSizeWidget {
  final TabBar child;

  IgnorePointerTabBarWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: child);
  }

  @override
  Size get preferredSize => this.child.preferredSize;
}
