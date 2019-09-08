/*import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_stripe/src/DefaultStripeController.dart';
import 'package:easy_stripe/src/StripeSourceModel.dart';
import 'package:easy_stripe/src/StripeSourceView.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


typedef V ValueCreator<V>(BuildContext context);


class StripeSourceField extends FormField<StripeSourceModel> {
  final StripeManager manager;
  final StripePickerBone bone;
  final AsyncValueGetter<StripeSourceModel> picker;

  StripeSourceField({Key key,
    @required this.manager, this.picker, this.bone,
  }) : super(key: key,
    builder: (FormFieldState<StripeSourceModel> state) {
      final _StripeSourceFieldState _state = state;
      void picking() async {
        _state.didChange(await picker());
      }

      return StreamBuilder<StripePickerSheet>(
        stream: bone.outFieldSheet,
        builder: (_, snap) {
          if (_state.value != snap.data?.value)
            _state.didChange(snap.data);

          if (snap.connectionState == ConnectionState.none)
            return Center(child: CircularProgressIndicator(),);

          if (!snap.hasData)
            return InkWell(
              onTap: picking,
              child: NoPaymentCard(),
            );

          return InkWell(
            onTap: picking,
            child: StripeSourceView(
              manager: manager,
              model: snap.data,
            ),
          );
        },
      );
    },
  );

  @override
  _StripeSourceFieldState createState() => _StripeSourceFieldState();
}

class _StripeSourceFieldState extends FormFieldState<StripeSourceModel> {

}

abstract class StripePickerBone extends FieldBone<StripeSourceModel, StripePickerSheet> {

}

class StripePickerSkeleton extends FieldSkeleton<StripeSourceModel, StripePickerSheet> implements StripePickerBone {
  @override
  void onSaved(StripeSourceModel value) {
    TextFormField()
  }
}


class StripePickerSheet extends FieldSheet<StripeSourceModel> {

}*/
