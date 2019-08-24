import 'dart:collection';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/src/database/Models.dart';
import 'package:easy_firebase/src/database/Resolver.dart';
import 'package:json_annotation/json_annotation.dart';


T caster<T>(dynamic value) {
  switch (T) {
    case String: {
      return value as T;
    } break;
    case int: {
      return int.tryParse(value) as T;
    } break;
    case double: {
      return double.tryParse(value) as T;
    } break;
    default:
      return resolverFromJson(T, value);
  }
}


/// Nella classe che contiene questi oggetti deve essere presente @JsonSerializable()
/// con parametri (anyMap: true, explicitToJson: true)


/// Ordine crescente
/// {V: true, V: true, V: true}
@JsonSerializable(createFactory: false, createToJson: false,)
class ArrayFirst<V> extends ListBase<V>{ //ArrayBool
  final List<V> _ls;

  ArrayFirst(this._ls);

  @override
  int get length => _ls.length;

  @override
  set length(int newLength) => _ls.length = newLength;

  @override
  V operator [](int index) => _ls[index];

  @override
  void operator []=(int index, V value) => _ls[index] = value;

  factory ArrayFirst.fromJson(Map<String, dynamic> map) =>
      ArrayFirst(map.keys.map((value) => caster<V>(value)).cast<V>().toList());

  Map<V, bool> toJson() {
    final _map = Map<V, bool>();
    _ls.forEach((val) => _map[val] = true);
    return _map;
  }
}


/// {0: V, 1: V, 2: V}
@JsonSerializable(createFactory: false, createToJson: false,)
class Array<V> extends ListBase<V> {
  final List<V> _ls;

  Array(this._ls);

  @override
  int get length => _ls.length;

  @override
  set length(int newLength) => _ls.length = newLength;

  @override
  V operator [](int index) => _ls[index];

  @override
  void operator []=(int index, V value) => _ls[index] = value;

  factory Array.fromJson(Map<String, dynamic> map) {
    return Array((map.keys.toList()..sort()).map((key) {
      return caster<V>(map[key]);
    }).cast<V>().toList());
  }

  Map<String, dynamic> toJson() => _ls.asMap().map((index, value) {
    return MapEntry('$index', value is JsonRule
        ? (value is FirebaseModel ? (value.toJson()..remove('id')..remove('path'))
        : value.toJson()) : value);
  });
}

/// {"ad32c34vfa4v": (...), "scn39c329r43vt53": (...), "48n4yv785y934": (...)}
@JsonSerializable(createFactory: false, createToJson: false,)
class ArrayDocObj<O extends PartialDocumentModel> extends ListBase<O>{
  final List<O> _ls;

  ArrayDocObj(this._ls) : assert(_ls != null);

  @override
  int get length => _ls.length;

  @override
  set length(int newLength) => _ls.length = newLength;

  @override
  O operator [](int index) => _ls[index];

  @override
  void operator []=(int index, O value) => _ls[index] = value;

  factory ArrayDocObj.fromJson(Map<String, Map<String, dynamic>> map) {
    List<O> values = List();
    map.keys.forEach((key) => values.add(resolverFromJson(O, map[key]..['id'] = key)));
    return ArrayDocObj(values);
  }

  Map<String, Map<String, dynamic>> toJson() {
    final _map = Map<String, Map<String, dynamic>>();
    _ls.forEach((obj) => _map[obj.id] = obj.toJson());
    return _map;
  }
}









/// Ordine crescente
/// {"Guido": true, "Michele": true, "Francesco": true}
@JsonSerializable(createFactory: false, createToJson: false,)
@deprecated
class ArrayPrimitiveBool<V> extends ListBase<V>{ //ArrayBool
  final List<V> _ls;

  ArrayPrimitiveBool(this._ls);

  @override
  int get length => _ls.length;

  @override
  set length(int newLength) => _ls.length = newLength;

  @override
  V operator [](int index) => _ls[index];

  @override
  void operator []=(int index, V value) => _ls[index] = value;

  factory ArrayPrimitiveBool.fromJson(Map<String, bool> map) =>
      ArrayPrimitiveBool(map.keys.map((value) => caster<V>(value)).toList());

  Map<V, bool> toJson() {
    final _map = Map<V, bool>();
    _ls.forEach((val) => _map[val] = true);
    return _map;
  }
}

/// {0: "Michele", 1: "Guido", 2: "Francesco"}
@deprecated
@JsonSerializable(createFactory: false, createToJson: false,)
class ArrayNumPrimitive<V> extends ListBase<V> {
  final List<V> _ls;

  ArrayNumPrimitive(this._ls);

  @override
  int get length => _ls.length;

  @override
  set length(int newLength) => _ls.length = newLength;

  @override
  V operator [](int index) => _ls[index];

  @override
  void operator []=(int index, V value) => _ls[index] = value;

  factory ArrayNumPrimitive.fromJson(Map<String, dynamic> map) => ArrayNumPrimitive(map.values.map((v) => v as V).toList());

  Map<String, V> toJson() => _ls.asMap().cast<String, V>();
}

/// {"ad32c34vfa4v": true, "scn39c329r43vt53": true, "48n4yv785y934": true}
@deprecated
@JsonSerializable(createFactory: false, createToJson: false,)
class ArrayDocBool<T extends FirebaseModel> extends ListBase<T>{
  Iterable<String> _keys;
  List<T> _ls = const [];

  ArrayDocBool(this._keys);

  @override
  int get length => _ls.length;

  @override
  set length(int newLength) => _ls.length = newLength;

  @override
  T operator [](int index) => _ls[index];

  @override
  void operator []=(int index, T value) => _ls[index] = value;

  void resolve(List<T> models) {
    if (_keys == null) return;
    _ls = _keys.map((id) {
      return models.firstWhere((model) => model.id == id);
    }).toList();
    _keys = null;
  }

  factory ArrayDocBool.fromJson(Map<String, bool> map) => ArrayDocBool(map.keys);

  Map<String, bool> toJson() {
    final _map = Map<String, bool>();
    _ls.forEach((val) => _map[val.id] = true);
    return _map;
  }
}

/// {0: {...}, 1: {...}, 2: {...}}
@deprecated
@JsonSerializable(createFactory: false, createToJson: false,)
class ArrayNumMap<V extends JsonRule> extends ListBase<V>{
  final List<V> _ls;

  ArrayNumMap(this._ls);

  @override
  int get length => _ls.length;

  @override
  set length(int newLength) => _ls.length = newLength;

  @override
  V operator [](int index) => _ls[index];

  @override
  void operator []=(int index, V value) => _ls[index] = value;

  factory ArrayNumMap.fromJson(Map<String, Map<String, dynamic>> map) {
    List<V> values = List();
    map.values.forEach((value) {
      values.add(resolverFromJson(V, value));
    });
    return ArrayNumMap(values);
  }

  Map<String, Map<String, dynamic>> toJson() {
    return _ls.asMap().map((index, obj) => MapEntry('$index', obj.toJson()));
  }
}

