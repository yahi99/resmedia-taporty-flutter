import 'package:easy_blocs/src/checker/controllers/SubmitController.dart';
import 'package:easy_blocs/src/rxdart_extension/CacheStreamBuilder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


typedef Widget SubmitButtonBuilder(BuildContext context, VoidCallback onPressed);


class SubmitButton extends StatelessWidget {
  final SubmitController controller;
  final SubmitButtonBuilder builder;

  SubmitButton({Key key,
    @required this.controller,
    @required this.builder,
  }) : assert(controller != null), assert(builder != null), super(key: key);

  SubmitButton.raised({
    @required SubmitController controller,
    Widget child,
  }) : this(
    controller: controller,
    builder: (_, onPressed) {
      return RaisedButton(
        onPressed: onPressed,
        child: child,
      );
    },
  );

  SubmitButton.flat({
    @required SubmitController controller,
    Widget child,
  }) : this(
    controller: controller,
    builder: (_, onPressed) {
      return FlatButton(
        onPressed: onPressed,
        child: child,
      );
    },
  );

  @override
  Widget build(BuildContext _) {

    return CacheStreamBuilder<SubmitData>(
      stream: controller.outData,
      builder: (context, snap) {
        return builder(
          context,
          snap.data.event == SubmitEvent.WAITING ? controller.onSubmit : null,
        );
      },
    );
  }

/*SubmitButton.icon({
    @required SubmitController controller,
    WidgetBuilder onError: ((context) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("errore"),
      ));
    }),
    Widget icon,
  }) : this(
    controller: controller,
    builder: (context, onPressed) {
      return IconButton(
        onPressed: () async {
          final res = await instagram.sign(context);
          controller.solver(res);
          if (res == null)
            onError(context, lsdsa);
        },
        icon: icon,
      );
    },
  );*/
}