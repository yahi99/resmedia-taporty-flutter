import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/page/CartPage.dart';
import 'package:resmedia_taporty_customer/interface/page/ConfirmPage.dart';
import 'package:resmedia_taporty_customer/interface/page/PaymentPage.dart';
import 'package:resmedia_taporty_customer/interface/page/ShippingPage.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';

class CheckoutScreen extends StatefulWidget {
  final GeoPoint customerCoordinates;
  final String customerAddress;

  CheckoutScreen({Key key, @required this.customerCoordinates, @required this.customerAddress}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class Continue {
  static bool isContinued;
}

class _CheckoutScreenState extends State<CheckoutScreen> with TickerProviderStateMixin {
  static TabController controller;
  int indexUser;

  var supplierBloc = $Provider.of<SupplierBloc>();
  var userBloc = $Provider.of<UserBloc>();

  @override
  void initState() {
    Continue.isContinued = false;
    controller = TabController(vsync: this, length: 4)..addListener(() {});
    indexUser = 0;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Paga'),
          backgroundColor: ColorTheme.RED,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.pushNamed(context, "/account");
              },
            )
          ],
          bottom: MyTabBar(
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
                    Icons.location_on,
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
            builder: (ctx, userSnapshot) {
              return StreamBuilder<SupplierModel>(
                stream: supplierBloc.outSupplier,
                builder: (_, supplierSnapshot) {
                  if (userSnapshot.hasData && supplierSnapshot.hasData) {
                    var user = userSnapshot.data;
                    var supplier = supplierSnapshot.data;
                    if (supplierSnapshot.data.isDisabled != null && supplierSnapshot.data.isDisabled) {
                      return Padding(
                        child: Text('Ristorante non abilitato scegline un\'altro'),
                        padding: EdgeInsets.all(8.0),
                      );
                    }
                    return CheckoutScreenInheritedWidget(
                      child: TabBarView(
                        controller: controller,
                        physics: NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          CartPage(
                            supplier: supplier,
                            controller: controller,
                          ),
                          ShippingPage(
                            user: user,
                            customerCoordinates: widget.customerCoordinates,
                            supplier: supplier,
                            controller: controller,
                          ),
                          PaymentPage(
                            controller,
                          ),
                          ConfirmPage(
                            supplier: supplier,
                            customerCoordinates: widget.customerCoordinates,
                            customerAddress: widget.customerAddress,
                            controller: controller,
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
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

class CheckoutScreenInheritedWidget extends InheritedWidget {
  final CheckoutDataModel data;

  CheckoutScreenInheritedWidget({Key key, @required Widget child})
      : assert(child != null),
        data = CheckoutDataModel(),
        super(key: key, child: child);

  static CheckoutDataModel of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<CheckoutScreenInheritedWidget>()).data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

class MyTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar child;

  MyTabBar({this.child});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: child);
  }

  @override
  Size get preferredSize => this.child.preferredSize;
}
