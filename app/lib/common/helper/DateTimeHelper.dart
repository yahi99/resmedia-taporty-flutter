import 'package:intl/intl.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';

class DateTimeHelper {
  static String getDateTimeString(DateTime datetime) {
    return DateFormat("d MMMM", "it").format(datetime) + " alle " + DateFormat("HH:mm").format(datetime);
  }

  static String getDateString(DateTime datetime) {
    var string = DateFormat("EEEEE d MMMM yyyy", "it").format(datetime);
    return string.replaceRange(0, 1, string.substring(0, 1).toUpperCase());
  }

  static String getShiftString(ShiftModel shift) {
    return getTimeString(shift.startTime) + " - " + getTimeString(shift.endTime);
  }

  static String getTimeString(DateTime datetime) {
    return DateFormat("HH:mm", "it").format(datetime);
  }
}
