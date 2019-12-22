
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/OrdersPage.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:rubber/rubber.dart';

final house = LatLngModel(lat: 45.386485, lng: 11.895141);

/*List<DriverOrderModel> currentOrder = [
  DriverOrderModel(
    supplier: SubjectModel(
      title: 'Burger King', address: 'viale Europa, 2',
      position: LatLngModel(lat:45.386485, lng:11.895141),
    ),
    receiver: SubjectModel(
      title: 'Mario Rossi', address: 'viale America, 5',
      position: house,
    ),
    id: 'ASjdsa8cajASjds93', time: '',
  ),
  DriverOrderModel(
    supplier: SubjectModel(
      title: 'Mac Donalds', address: 'viale Europa, 2',
      position: LatLngModel(lat:45.416967, lng:11.879364)
    ),
    receiver: SubjectModel(
      title: 'Luisa Bianchi', address: 'viale America, 5',
      position: house,
    ),
    id: 's763Budsa8Jjsdf732', time: '',
  ),
];*/

/*List<OrderModel> sentOrder = [
  OrderModel(
    supplier: SubjectModel(
      title: 'Mac Donalds', address: 'viale Europa, 2',
      position: LatLng(45.416967, 11.879364),
    ),
    receiver: SubjectModel(
      title: 'Luigi Bianchi', address: 'viale America, 5',
      position: HOUSE,
    ),
    id: 'SJNad3frf4vfFasA', time: '',
  ),
  OrderModel(
    supplier: SubjectModel(
      title: 'America Graffiti', address: 'viale Europa, 2',
      position: LatLng(45.303240, 12.020175),
    ),
    receiver: SubjectModel(
      title: 'Maro Cross', address: 'viale America, 5',
      position: HOUSE,
    ),
    id: 'JDNDdfds77993', time: '',
  ),
  OrderModel(
    supplier: SubjectModel(
      title: 'La Valle del Gusto', address: 'viale Europa, 2',
      position: LatLng(45.303240, 12.020175),
    ),
    receiver: SubjectModel(
      title: 'Luigina Pierina', address: 'viale America, 5',
      position: HOUSE,
    ),
    id: 'sad877SAsda8sad8a', time: '',
  ),
  OrderModel(
    supplier: SubjectModel(
      title: 'Antico Ritrovo', address: 'viale Europa, 2',
      position: LatLng(45.303240, 12.020175),
    ),
    receiver: SubjectModel(
      title: 'Amedeo Grigio', address: 'viale America, 5',
      position: HOUSE,
    ),
    id: 'sad77sadaSDas7d8sa', time: '',
  ),
];


Map<String, List<OrderModel>> orders = {
  "ORDINI CORRENTI": currentOrder,
  "ORDINI EVASI": sentOrder,
};*/

class OrdersTabDriver extends StatefulWidget {
  final Map<StateCategory, List<DriverOrderModel>> model;

  OrdersTabDriver({
    @required this.model,
  });

  @override
  _OrdersTabDriverState createState() => _OrdersTabDriverState();
}

class _OrdersTabDriverState extends State<OrdersTabDriver>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  RubberAnimationController _rubberController;

  @override
  void initState() {
    super.initState();
    final halfValue = AnimationControllerValue(percentage: 0.6);
    _scrollController = ScrollController();
    _rubberController = RubberAnimationController(
      vsync: this,
      initialValue: halfValue.percentage,
      halfBoundValue: halfValue,
      upperBoundValue: AnimationControllerValue(percentage: 1),
      duration: Duration(milliseconds: 500),
    );
  }

  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final tt = Theme.of(context).textTheme;

    return RubberBottomSheet(
      animationController: _rubberController,
      scrollController: _scrollController,
      lowerLayer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Material(
            elevation: 4.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: SPACE, vertical: 8.0),
              child: Text(
                "Ordine N ",
                style: tt.subhead,
              ),
            ),
          ),
          OrdersPageDriver(model: widget.model),

          /*GroupsVoid(
            children:widget.model.map<Widget, List<Widget>>((nameGroup, products) {
                return MapEntry(
                  Text(translateOrderCategory(nameGroup)),
                  products
                      .map((product) => InkWell(
                    onTap: () {
                      EasyRouter.push(context,OrdersPageDriver());
                    },
                      child:OrderView(
                    model: product,
                  )))
                      .toList(),
                );
              }),
          ),*/

          /*Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),*/
          /*Expanded(
              child: PocketMapBuilder(
                padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0, bottom: 64.0),
                builder: (context, onMapCreated) {
                  return PocketMap(
                    onMapCreated: (controller) {
                      onMapCreated(controller.basicController);
                      _mapController.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target:LatLng(house.lat,house.lng),
                      //target: centerPos(currentOrder.map((_model) => _model.supplier.position)),
                      zoom: 11,
                    ),
                  );
                },
              ),
            ),*/
        ],
      ),
      upperLayer: Material(
        elevation: 16.0,
        child: Navigator(
          initialRoute: OrdersPageDriver.ROUTE,
          onGenerateRoute: EasyRouter.onGenerateRouteBuilder(
              (_) => OrdersPageDriver(model: widget.model),
              OrdersPageDriver.ROUTE),
        ),
      ),
    );
  }

  Widget _addControllers({@required Widget child}) {
    return RubberScrollController(
      controller: _scrollController,
      child: PrimaryRubberController(
        controller: _rubberController,
        child: Container(),
        /*PrimaryGoogleMapsController(
          controller: _mapController,
          child: child,
        ),*/
      ),
    );
  }

  @override
  
  bool get wantKeepAlive => true;
}

class RubberScrollController extends InheritedWidget {
  final ScrollController controller;

  const RubberScrollController({
    Key key,
    @required this.controller,
    @required Widget child,
  })  : assert(controller != null),
        assert(child != null),
        super(key: key, child: child);

  static ScrollController of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(RubberScrollController)
            as RubberScrollController)
        ?.controller;
  }

  @override
  bool updateShouldNotify(RubberScrollController old) {
    return true;
  }
}
