import 'package:easy_blocs/src/checker/checkers/Checker.dart';
import 'package:easy_blocs/src/checker/checkers/StringChecker.dart';
import 'package:easy_blocs/src/checker/widget/CheckerField.dart';
import 'package:easy_blocs/src/translator/TranslationsModel.dart';
import 'package:easy_blocs/src/translator/TranslatorController.dart';
import 'package:flutter/material.dart';

class StringField extends CheckerField<String> {
  StringField({Key key,
    @required CheckerRule<String, String> checker,
    Translator translator: translatorStringField,
    InputDecoration decoration: const InputDecoration(),
    bool defaultDecoration: true,@required bool obscure,bool isLast
  }) : assert(checker != null), assert(decoration != null), super(key: key,
    checker: checker, translator: translator,
    decoration: decoration,obscure:obscure,isLast:isLast,
  );

}


Translations translatorStringField(Object error) {
  switch (error) {
    case StringAuthError.EMPTY: {
      return const TranslationsConst(
        it: "Campo vuoto.",
        en: "Empty field.",
      );
    }
    case StringAuthError.INVALID: {
      return const TranslationsConst(
          it: "Formato non appropriato.",
          en: "Bad Format."
      );
    }
    default: return null;
  }
}