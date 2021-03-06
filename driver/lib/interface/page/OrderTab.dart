import 'package:flutter/material.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderListBloc.dart';
import 'package:resmedia_taporty_driver/interface/view/OrderView.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';

class OrderTab extends StatefulWidget {
  @override
  _OrderTabState createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  final orderListBloc = $Provider.of<OrderListBloc>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<List<OrderModel>>(
        stream: orderListBloc.outOrders,
        builder: (_, orderListSnapshot) {
          if (orderListSnapshot.connectionState == ConnectionState.active) {
            if (orderListSnapshot.hasData && orderListSnapshot.data.length > 0) {
              var categorizedOrders = categorized<DriverOrderState, OrderModel>(DriverOrderState.values, orderListSnapshot.data, (order) => orderStateToDriverOrderState(order.state));
              categorizedOrders.remove(DriverOrderState.HIDDEN);
              return SingleChildScrollView(
                child: Column(
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
                                  onTap: () {
                                    $Provider.of<OrderBloc>().setOrderStream(orders[index].id);
                                    Navigator.pushNamed(
                                      _context,
                                      "/orderDetail",
                                    );
                                  },
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
                ),
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
    );
  }
}
