import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/DetailOrderPage.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/OrderView.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

class OrderTab extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrderTab";

  String get route => OrderTab.ROUTE;

  OrderTab();

  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  final orderBloc = OrderBloc.of();
  bool isDeactivate = false;

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      body: (widget.model.length > 0)
          ? CustomScrollView(
              //controller: RubberScrollController.of(context),
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              slivers: widget.model.keys.map<Widget>(
                (nameGroup) {
                  final driverOrderModels = widget.model[nameGroup];
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    sliver: SliverOrderVoid(
                      title: Text(translateOrderState(nameGroup)),
                      childCount: driverOrderModels.length,
                      builder: (_context, index) {
                        return InkWell(
                          onTap: () => EasyRouter.push(
                              _context,
                              DetailOrderPageDriver(
                                model: driverOrderModels[index],
                              )),
                          child: OrderView(
                            orderModel: driverOrderModels[index],
                          ),
                        );
                      },
                    ),
                  );
                },
              ).toList(),
            )
          : Padding(
              child: Text('Non ci sono ordini.'),
              padding: EdgeInsets.all(8.0),
            ),
    );*/
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<List<OrderModel>>(
          stream: orderBloc.outDriverOrders,
          builder: (_, orderListSnapshot) {
            if (orderListSnapshot.connectionState == ConnectionState.active) {
              if (orderListSnapshot.hasData && orderListSnapshot.data.length > 0) {
                var categorizedOrders = categorized<DriverOrderState, OrderModel>(DriverOrderState.values, orderListSnapshot.data, (order) => orderStateToDriverOrderState(order.state));
                categorizedOrders.remove(DriverOrderState.HIDDEN);
                return Column(
                  children: categorizedOrders.keys.map<Widget>(
                    (orderState) {
                      final orders = categorizedOrders[orderState];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                translateDriverOrderState(orderState),
                                style: theme.textTheme.title,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: orders.length,
                              itemBuilder: (_context, index) {
                                return InkWell(
                                  onTap: () => EasyRouter.push(
                                    _context,
                                    DetailOrderPageDriver(
                                      model: orders[index],
                                    ),
                                  ),
                                  child: OrderView(
                                    order: orders[index],
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ).toList(),
                );
              }
              return Padding(
                child: Text('Non ci sono ordini a te assegnati.'),
                padding: EdgeInsets.all(16.0),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
