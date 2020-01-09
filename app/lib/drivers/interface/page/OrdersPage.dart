import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/DetailOrderPage.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/OrderView.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

class OrdersPageDriver extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrdersPageDriver";

  String get route => OrdersPageDriver.ROUTE;

  final Map<OrderState, List<OrderModel>> model;

  OrdersPageDriver({
    @required this.model,
  });

  @override
  _OrdersPageDriverState createState() => _OrdersPageDriverState();
}

class _OrdersPageDriverState extends State<OrdersPageDriver> {
  bool isDeactivate = false;

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
