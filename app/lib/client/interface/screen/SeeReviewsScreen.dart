import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/SupplierBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/SupplierModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ReviewModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';

class SeeReviewsScreen extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "SeeReviewsScreen";

  String get route => SeeReviewsScreen.ROUTE;
  final SupplierModel model;

  SeeReviewsScreen({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<SeeReviewsScreen> {
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
        title: Text('Recensioni ' + widget.model.id),
        backgroundColor: ColorTheme.RED,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: SupplierBloc.init(supplierId: widget.model.id).outSupplierReview,
        builder: (ctx, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snap.data.length == 0)
            return Padding(
              child: Text(
                'Non ci sono recensioni per questo ristorante',
                style: Theme.of(context).textTheme.subtitle,
              ),
              padding: EdgeInsets.all(8.0),
            );
          print(snap.data.length);
          return ListView.separated(
            itemCount: snap.data.length,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              final model = snap.data.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(child: Review(model: model)),
              );
            },
            separatorBuilder: (ctx, index) {
              return Divider(
                height: 4.0,
              );
            },
          );
        },
      ),
    );
  }
}

class Review extends StatelessWidget {
  final ReviewModel model;

  Review({@required this.model});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Text(
            model.customerName,
            style: tt.subtitle,
          ),
          padding: EdgeInsets.all(8.0),
        ),
        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(model.description),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: <Widget>[
                    Text(model.rating.toString()),
                    Icon(Icons.star),
                  ],
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 8.0),
        ),
      ],
    );
  }
}
