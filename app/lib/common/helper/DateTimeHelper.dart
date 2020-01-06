import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getDateString(DateTime datetime) {
    return DateFormat("d MMMM", "it").format(datetime) + " alle " + DateFormat("HH:mm").format(datetime);
  }
}
