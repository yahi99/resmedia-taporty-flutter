import 'package:cloud_firestore/cloud_firestore.dart';

DateTime datetimeFromTimestamp(Timestamp input) {
  if (input == null) return null;
  return input.toDate();
}

Timestamp datetimeToTimestamp(DateTime input) {
  if (input == null) return null;
  return Timestamp.fromDate(input);
}
