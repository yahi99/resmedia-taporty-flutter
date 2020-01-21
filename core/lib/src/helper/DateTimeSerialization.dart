import 'package:cloud_firestore/cloud_firestore.dart';

DateTime datetimeFromJson(dynamic input) {
  if (input == null) return null;
  var timestamp = input as Timestamp;
  return timestamp.toDate();
}

dynamic datetimeToJson(DateTime input) {
  if (input == null) return null;
  return Timestamp.fromDate(input);
}
