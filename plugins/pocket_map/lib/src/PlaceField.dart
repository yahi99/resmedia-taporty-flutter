/*import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:rxdart/rxdart.dart';


class PlaceFieldSheet {
  final bool enable;

  const PlaceFieldSheet({this.enable});

  PlaceFieldSheet copyWith({FieldError error, bool enable}) {
    return PlaceFieldSheet(
      enable: enable??this.enable,
    );
  }
}


abstract class PlaceFieldBone implements FieldBone<String> {
  String get apiKey;
  Stream<Data2<FieldError, PlaceFieldSheet>> get outErrorAndSheet;
}


class PlaceFieldSkeleton extends FieldSkeleton<String> implements PlaceFieldBone {
  final String apiKey;

  PlaceFieldSkeleton({
    String seed,
    List<FieldValidator<String>> validators,
    @required this.apiKey,
  }): assert (apiKey != null), super(
    validators: validators??[TextFieldValidator.undefined],
  );

  @override
  void dispose() {
    _sheetController.close();
    super.dispose();
  }

  BehaviorSubject<PlaceFieldSheet> _sheetController = BehaviorSubject.seeded(const PlaceFieldSheet());
  Stream<PlaceFieldSheet> get outSheet => _sheetController;
  PlaceFieldSheet get sheet => _sheetController.value;
  void inSheet(PlaceFieldSheet sheet) => _sheetController.add(sheet);

  Stream<Data2<FieldError, PlaceFieldSheet>> _outErrorAndSheet;
  Stream<Data2<FieldError, PlaceFieldSheet>> get outErrorAndSheet {
    if (_outErrorAndSheet == null)
      _outErrorAndSheet = Data2.combineLatest(outError, outSheet);
    return _outErrorAndSheet;
  }

  @override
  void inFieldState(FieldState state) => inSheet(sheet.copyWith(enable: state == FieldState.active));
}


class PlaceFieldShell extends StatefulWidget
    implements FieldShell, FocusShell {
  final PlaceFieldBone bone;

  @override
  final FocuserBone mapFocusBone;
  @override
  final FocusNode focusNode;

  final FieldErrorTranslator nosy;
  final InputDecoration decoration;

  const PlaceFieldShell({Key key,
    @required this.bone,
    this.mapFocusBone, this.focusNode,
    this.nosy: byPassNoisy, this.decoration: const TranslationsInputDecoration(
      prefixIcon: Icon(Icons.home),
      translationsHintText: TranslationsConst(
        it: "Indirzzo",
        en: "Address",
      ),
    ),
  }) :
        assert(bone != null),
        assert(nosy != null), super(key: key);

  @override
  _PlaceFieldShellState createState() => _PlaceFieldShellState();
}

class _PlaceFieldShellState extends State<PlaceFieldShell>
    with FieldStateMixin, FocusShellStateMixin {
  RepositoryBlocBase _repositoryBloc = RepositoryBlocBase.of();
  TextEditingController _controller = TextEditingController();

  ObservableSubscriber<String> _valueSubscriber;
  ObservableSubscriber<Data2<FieldError, PlaceFieldSheet>> _dataSubscriber;
  Data2<FieldError, PlaceFieldSheet> _data;

  @override
  void initState() {
    super.initState();
    _valueSubscriber = ObservableSubscriber(_valueListener)..subscribe(widget.bone.outValue);
    _dataSubscriber = ObservableSubscriber(_dataListener)..subscribe(widget.bone.outErrorAndSheet);
  }

  @override
  void didUpdateWidget(PlaceFieldShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bone != oldWidget.bone) {
      _valueSubscriber..unsubscribe()..subscribe(widget.bone.outValue);
      _dataSubscriber..unsubscribe()..subscribe(widget.bone.outErrorAndSheet);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _valueSubscriber.unsubscribe();
    _dataSubscriber.unsubscribe();
    super.dispose();
  }

  void _valueListener(ObservableState<String> update) {
    _controller.text = update.data;
  }
  void _dataListener(ObservableState<Data2<FieldError, PlaceFieldSheet>> update) {
    setState(() => _data = update.data);
  }

  @override
  Widget build(BuildContext context) {

    return PlacesAutocompleteField(
      controller: _controller,
      apiKey: widget.bone.apiKey,
      language: _repositoryBloc.locale.languageCode,
      onChanged: widget.bone.inTmpValue,
      inputDecoration: widget.decoration.copyWith(
        errorText: widget.nosy(_data.data1)?.text,
      ),
      hint: widget.decoration.hintText,
    );
  }
}



*/