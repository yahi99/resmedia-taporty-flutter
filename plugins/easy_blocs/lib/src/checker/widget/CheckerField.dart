import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:flutter/material.dart';


class CheckerField<V> extends CacheStreamBuilder<DataField<V>> {
  CheckerField({Key key,
    @required CheckerRule<V, String> checker, Translator translator,
    InputDecoration decoration: const InputDecoration(), @required bool obscure, bool isLast
  }) : super(
    key: key,
    stream: checker.outData,
    builder: (context, snap) {

      final data = snap.data;

      return TextFormField(
        initialValue: data.text,
        focusNode: checker.focusNode,
        decoration: decoration.copyWith(
          errorText: translator(snap.data.error)?.text,
          errorMaxLines: decoration.errorMaxLines??2,
        ),
        keyboardType: checker.keyboardType,
        obscureText: obscure,

        maxLength: checker.maxLength,

        onFieldSubmitted: (_) {
            if(isLast==null || !isLast) checker.nextFinger(context);
            else{
              checker.focusNode.unfocus();
            }
          },
        onSaved: checker.onSaved, //(value) => checker.add(data.copyWith(value: onSaved(value))),//(text) => checker.add(data.copyWith(text: text)),
        validator: (value) => translator(checker.validate(value))?.text,
        inputFormatters: checker.inputFormatters,
      );
    },
  );
}