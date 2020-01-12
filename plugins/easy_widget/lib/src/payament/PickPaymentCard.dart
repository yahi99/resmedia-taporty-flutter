import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';

class PickPaymentCardDialog extends StatelessWidget {
  final VoidCallback onAddPaymentCard;
  final Stream<List<Widget>> outCards;

  const PickPaymentCardDialog({
    Key key,
    @required this.onAddPaymentCard,
    @required this.outCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        constraints: BoxConstraints(maxHeight: 300),
        child: StreamBuilder<List<Widget>>(
          stream: outCards,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            final cards = snapshot.data;
            if (cards.length < 1) return NoPaymentCard();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListViewSeparated.builder(
                  shrinkWrap: true,
                  itemCount: cards.length,
                  separator: const Divider(),
                  itemBuilder: (_, index) {
                    final card = cards[index];
                    return card;
                  },
                ),
              ],
            );
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Annulla"),
        ),
        FlatButton(
          onPressed: onAddPaymentCard,
          child: Text("Crea Nuova Carta"),
        ),
      ],
    );
  }
}
