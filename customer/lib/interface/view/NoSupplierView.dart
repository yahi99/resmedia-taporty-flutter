import 'package:flutter/material.dart';

// TODO: Rendi più bella e personalizza in base al motivo per cui non ci sono fornitori (searchbar, filtri o altro)
class NoSupplierView extends StatelessWidget {
  const NoSupplierView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("Non sono disponibili fornitori corrispondenti ai criteri di ricerca."),
      ),
    );
  }
}
