import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/ReviewBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:toast/toast.dart';

class ReviewAlertDialog extends StatefulWidget {
  final bool isSupplierReview;
  final ReviewModel review;
  ReviewAlertDialog(this.review, this.isSupplierReview, {Key key}) : super(key: key);

  @override
  _ReviewAlertDialogState createState() => _ReviewAlertDialogState();
}

class _ReviewAlertDialogState extends State<ReviewAlertDialog> {
  TextEditingController _reviewBodyController;
  double _rating;

  @override
  void initState() {
    _rating = widget.review?.rating ?? 5;
    _reviewBodyController = new TextEditingController(text: widget.review?.description ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  child: AutoSizeText(widget.isSupplierReview ? 'Recensione fornitore' : 'Recensione fattorino'),
                  padding: EdgeInsets.only(bottom: 12.0, right: 12.0),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RatingBar(
                  initialRating: _rating,
                  onRatingChanged: (val) {
                    _rating = val;
                  },
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  halfFilledIcon: Icons.star_half,
                  isHalfAllowed: true,
                  emptyColor: Colors.yellow,
                  filledColor: Colors.yellow,
                  halfFilledColor: Colors.yellow,
                  size: 25.0,
                ),
              ],
            ),
            Padding(
              child: TextFormField(
                controller: _reviewBodyController,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.length == 0) {
                    return 'Inserisci valutazione';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Inserisci una recensione...",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                ),
                maxLines: 10,
                minLines: 5,
                keyboardType: TextInputType.text,
              ),
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  child: Text('Invia'),
                  onPressed: () async {
                    try {
                      await $Provider.of<ReviewBloc>().setReview(_rating, _reviewBodyController.text);
                      Toast.show("Recensione aggiunta con successo!", context);
                      Navigator.pop(context);
                    } catch (err) {
                      Toast.show("Errore inaspettato!", context);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
