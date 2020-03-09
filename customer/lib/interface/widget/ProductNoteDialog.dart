import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ProductNoteDialog extends StatefulWidget {
  final String defaultNotes;
  final Function(String) onConfirm;
  ProductNoteDialog({this.defaultNotes, @required this.onConfirm, key}) : super(key: key);

  @override
  _ProductNoteDialogState createState() => _ProductNoteDialogState();
}

class _ProductNoteDialogState extends State<ProductNoteDialog> {
  TextEditingController _noteBodyController;

  @override
  void initState() {
    _noteBodyController = new TextEditingController(text: widget.defaultNotes ?? "");
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
                  child: AutoSizeText('Nota per il fornitore'),
                  padding: EdgeInsets.only(bottom: 8.0, right: 12.0),
                ),
              ],
            ),
            Padding(
              child: TextFormField(
                controller: _noteBodyController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: "Inserisci ciò che vuoi far sapere al fornitore...",
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
                  child: Text('Aggiungi'),
                  onPressed: () => widget.onConfirm(_noteBodyController.text),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
