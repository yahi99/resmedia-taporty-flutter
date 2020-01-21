import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/CartPage.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/ConfirmPage.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/PaymentPage.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/ShippingPage.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/SupplierBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/SupplierModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';

class CheckoutScreen extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ProductsScreen";

  String get route => CheckoutScreen.ROUTE;
  final SupplierModel supplier;
  final UserModel user;
  final GeoPoint customerCoordinates;
  final String customerAddress;

  CheckoutScreen({Key key, @required this.supplier, @required this.user, @required this.customerCoordinates, @required this.customerAddress}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class Continue {
  static bool isContinued;
}

class _CheckoutScreenState extends State<CheckoutScreen> with TickerProviderStateMixin {
  static TabController controller;
  int indexUser;

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
                EasyRouter.push(context, AccountScreen());
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
          child: StreamBuilder<User>(
            stream: UserBloc.of().outUser,
            builder: (ctx, user) {
              return StreamBuilder<SupplierModel>(
                stream: SupplierBloc.init(supplierId: widget.supplier.id).outSupplier,
                builder: (ctx, rest) {
                  if (!user.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return StreamBuilder(
                    stream: Database().getUser(user.data.userFb),
                    builder: (ctx, model) {
                      if (user.hasData && rest.hasData && model.hasData) {
                        if (model.data.type != 'user' && model.data.type != null) {
                          return RaisedButton(
                            child: Text('Sei stato disabilitato clicca per fare logout'),
                            onPressed: () {
                              UserBloc.of().logout();
                              LoginHelper().signOut();
                              EasyRouter.pushAndRemoveAll(context, LoginScreen());
                            },
                          );
                          //EasyRouter.pushAndRemoveAll(context, LoginScreen());
                        }
                        if (rest.data.isDisabled != null && rest.data.isDisabled) {
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
                                supplier: widget.supplier,
                                controller: controller,
                              ),
                              ShippingPage(
                                user: widget.user,
                                customerCoordinates: widget.customerCoordinates,
                                supplier: widget.supplier,
                                controller: controller,
                              ),
                              PaymentPage(
                                controller,
                              ),
                              ConfirmPage(
                                supplier: widget.supplier,
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
              );
            },
          ),
        ),
      ),
    );
  }
}

class CheckoutScreenInheritedWidget extends InheritedWidget {
  final CheckoutScreenData data;

  CheckoutScreenInheritedWidget({Key key, @required Widget child})
      : assert(child != null),
        data = CheckoutScreenData(),
        super(key: key, child: child);

  static CheckoutScreenData of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType<CheckoutScreenInheritedWidget>()).data;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}

class CheckoutScreenData {
  String name, email, phone, cardId, customerId;
  ShiftModel selectedShift;

  int productCount; // TODO: Rimuovere dopo il refactoring delle classi Cart
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
