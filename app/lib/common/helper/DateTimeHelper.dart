import 'package:intl/intl.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';

class DateTimeHelper {
  static String getDateString(DateTime datetime) {
    return DateFormat("d MMMM", "it").format(datetime) + " alle " + DateFormat("HH:mm").format(datetime);
  }

  static String getShiftString(ShiftModel shift) {
    return DateFormat("HH:mm").format(shift.startTime) + " - " + DateFormat("HH:mm").format(shift.endTime);
  }
}
