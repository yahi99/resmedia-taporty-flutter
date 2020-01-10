import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/OrderView.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:resmedia_taporty_flutter/client/interface/page/OrderDetailPage.dart';
import 'package:sticky_headers/sticky_headers.dart';

class OrderScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrderScreen";

  @override
  String get route => OrderScreen.ROUTE;

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  final _orderBloc = OrderBloc.of();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Ordini'),
        backgroundColor: ColorTheme.RED,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: CacheStreamBuilder<List<OrderModel>>(
        stream: _orderBloc.outUserOrders,
        builder: (context, orderListSnapshot) {
          if (orderListSnapshot.connectionState == ConnectionState.active) {
            if (orderListSnapshot.hasData && orderListSnapshot.data.length > 0) {
              var firstMonth = DateTimeHelper.getMonthYear(orderListSnapshot.data.first.creationTimestamp);
              var lastMonth = DateTimeHelper.getMonthYear(orderListSnapshot.data.first.creationTimestamp);
              var currentDate = DateTime(orderListSnapshot.data.first.creationTimestamp.year, orderListSnapshot.data.first.creationTimestamp.month);
              var monthCategories = List<String>();
              do {
                monthCategories.add(firstMonth);
                if (currentDate.month == 1)
                  currentDate = DateTime(currentDate.year - 1, 12);
                else
                  currentDate = DateTime(currentDate.year, currentDate.month - 1);
              } while (monthCategories.last != lastMonth);
              monthCategories.add(lastMonth);

              var categorizedOrders = categorized<String, OrderModel>(monthCategories, orderListSnapshot.data, (order) => DateTimeHelper.getMonthYear(order.creationTimestamp));
              return SingleChildScrollView(
                child: Column(
                  children: categorizedOrders.keys.map<Widget>(
                    (monthCategory) {
                      final orders = categorizedOrders[monthCategory];
                      return StickyHeader(
                        header: Container(
                          color: ColorTheme.LIGHT_GREY,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Center(
                              child: Text(
                                monthCategory.toUpperCase(),
                              ),
                            ),
                          ),
                        ),
                        content: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => EasyRouter.push(
                                context,
                                OrderDetailPage(
                                  orderId: orders[index].id,
                                ),
                              ),
                              child: OrderView(
                                order: orders[index],
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => Divider(
                            color: Colors.grey,
                            height: 0,
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              );
            }
            return Padding(
              child: Text(
                'Non ci sono ordini.',
                style: Theme.of(context).textTheme.subtitle,
              ),
              padding: EdgeInsets.all(8.0),
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
