import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';

// TODO: Rendi più carino da vedere
class SupplierReviewListScreen extends StatefulWidget {
  final SupplierModel model;

  SupplierReviewListScreen({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  _SupplierReviewListScreenState createState() => _SupplierReviewListScreenState();
}

class _SupplierReviewListScreenState extends State<SupplierReviewListScreen> {
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