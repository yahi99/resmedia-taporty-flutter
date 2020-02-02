import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';

class SupplierReviewListScreen extends StatefulWidget {
  SupplierReviewListScreen({
    Key key,
  }) : super(key: key);

  @override
  _SupplierReviewListScreenState createState() => _SupplierReviewListScreenState();
}

class _SupplierReviewListScreenState extends State<SupplierReviewListScreen> {
  var supplierBloc = $Provider.of<SupplierBloc>();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recensioni',
          style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: ColorTheme.RED,
        centerTitle: false,
      ),
      body: StreamBuilder<List<ReviewModel>>(
        stream: supplierBloc.outSupplierReviews,
        builder: (ctx, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snap.data.length == 0)
            return Padding(
              child: Text(
                'Non ci sono recensioni per questo fornitore',
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
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                  child: ReviewView(review: model),
                )),
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

class ReviewView extends StatelessWidget {
  final ReviewModel review;

  ReviewView({@required this.review});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                review.customerName,
                style: tt.subtitle,
              ),
              Row(
                children: <Widget>[
                  Text(review.rating.toString()),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ],
          ),
          padding: EdgeInsets.all(8.0),
        ),
        Padding(
          child: Text(review.description),
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
        ),
      ],
    );
  }
}
