
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/control/interface/view/TypeCtrlOrderView.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ManageOrders extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ManageOrders";

  String get route => ROUTE;

  final List<RestaurantOrderModel>list;

  ManageOrders({this.list});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ManageOrders> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return (widget.list.length>0)?Scaffold(
      body:ListView.builder(
            itemCount: widget.list.length,
            shrinkWrap: true,
            itemBuilder: (ctx,index){
              final order=widget.list.elementAt(index);
              return Padding(child:TypeCtrlOrderView(model: order,),padding: EdgeInsets.only(top: 8.0),);
            },
          ),
    ):Padding(child: Text('Non ci sono ordini.',style: theme.textTheme.subtitle,),padding: EdgeInsets.all(8.0),);
  }
}