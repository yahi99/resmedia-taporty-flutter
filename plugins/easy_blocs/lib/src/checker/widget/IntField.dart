import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/IntChecker.dart';
import 'package:easy_blocs/src/checker/widget/CheckerField.dart';
import 'package:flutter/material.dart';


class IntField extends CheckerField<int> {
  IntField({Key key,
    @required CheckerRule<int, String> checker,
    Translator translator: translatorIntField,@required bool obscure,
    InputDecoration decoration: const InputDecoration(),
  }) : assert(checker != null), assert(decoration != null), super(key: key,
    checker: checker, translator: translator,
    decoration: decoration,obscure:obscure
  );
}


Translations translatorIntField(Object error) {
  switch (error) {
    case IntFieldError.EMPTY: {
      return const TranslationsConst(
        it: "Campo vuoto.",
        en: "Empty field.",
      );
    }
    case IntFieldError.INVALID: {
      return const TranslationsConst(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default: return null;
  }
}