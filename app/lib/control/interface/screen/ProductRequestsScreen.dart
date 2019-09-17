import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/RequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';

class ProductRequestsScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'TurnScreenPanel';

  @override
  String get route => ROUTE;

  @override
  _ProductRequestsScreenState createState() => _ProductRequestsScreenState();
}

class _ProductRequestsScreenState extends State<ProductRequestsScreen> {
  RequestsBloc reqBloc;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    RequestsBloc.instance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    reqBloc=RequestsBloc.of();
    return Scaffold(
      appBar: AppBar(
        title: Text("Richieste Prodotti"),
        actions: <Widget>[],
      ),
      body: StreamBuilder(
        stream:reqBloc.outRequests ,
        builder: (context,snap){
          if(!snap.hasData) return Center(child:CircularProgressIndicator());
          return ListView.builder(
            itemBuilder: (context,index){
              return ItemBuilder(model:snap.data.elementAt(index));
            },
            itemCount: snap.data.length,
          );
        },
      ),
    );
  }
}

class ItemBuilder extends StatelessWidget{

  final ProductRequestModel model;

  ItemBuilder({
    @required this.model
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(

        ),
      ],
    );
  }

}
