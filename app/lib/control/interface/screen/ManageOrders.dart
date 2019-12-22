
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/view/TypeCtrlOrderView.dart';


//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ManageOrders extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ManageOrders";

  String get route => ROUTE;

  final list;

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
    return Scaffold(
      body:ListView.separated(
            itemCount: widget.list.length,
            shrinkWrap: true,
            itemBuilder: (ctx,index){
              final order=widget.list.elementAt(index);
              return Padding(child:TypeCtrlOrderView(model: order,),padding: EdgeInsets.only(top: 8.0),);
            },
            separatorBuilder: (ctx,index){
              return Divider(height: 4.0,);
            },
          ),
    );
  }
}
