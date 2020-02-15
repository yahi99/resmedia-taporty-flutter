import 'package:cloud_firestore/cloud_firestore.dart';

DateTime datetimeFromTimestamp(dynamic input) {
  if (input == null) return null;
  var timestamp = input as Timestamp;
  return timestamp.toDate();
}

dynamic datetimeToTimestamp(DateTime input) {
  if (input == null) return null;
  return Timestamp.fromDate(input);
}
