import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_flutter/interface/page/CartPage.dart';
import 'package:resmedia_taporty_flutter/interface/page/ConfirmPage.dart';
import 'package:resmedia_taporty_flutter/interface/page/PaymentPage.dart';
import 'package:resmedia_taporty_flutter/interface/page/ShippingPage.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/mainRestaurant.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/model/ReviewModel.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';

class SeeReviewsDriverScreen extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "SeeReviewsDriverScreen";

  String get route => SeeReviewsDriverScreen.ROUTE;
  final UserModel model;

  SeeReviewsDriverScreen(
      {Key key,
        @required this.model,})
      : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<SeeReviewsDriverScreen>{

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
      appBar: AppBar(
        title: Text('Recensioni '+widget.model.nominative),
        backgroundColor: red,
        centerTitle: true,
        actions: <Widget>[
        ],
      ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: UserBloc.of().outDriverReview,
        builder: (ctx,snap){
          if(!snap.hasData) return Center(child: CircularProgressIndicator(),);
          return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (ctx,index){
              final model=snap.data.elementAt(index);
              return Review(model:model);
            },
            separatorBuilder: (ctx,index){
              return Divider(height: 4.0,);
            },
          );
        },
      ),
    );
  }
}

class Review extends StatelessWidget{

  final ReviewModel model;

  Review({@required this.model});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Text(model.nominative),
        Row(
          children: <Widget>[
            Text(model.strPoints),
            Text(model.points.toString()),
          ],
        ),
      ],
    );
  }

}
