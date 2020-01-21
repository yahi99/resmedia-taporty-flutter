import 'package:intl/intl.dart';
import 'package:resmedia_taporty_core/src/models/ShiftModel.dart';

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

  static String getMonthString(int monthId) {
    var string = DateFormat("MMMM").format(DateFormat("M").parse(monthId.toString(), true));
    return string.replaceRange(0, 1, string.substring(0, 1).toUpperCase());
  }

  static String getDayString(DateTime datetime) {
    var string = DateFormat("EEEEE d", "it").format(datetime);
    return string.replaceRange(0, 1, string.substring(0, 1).toUpperCase());
  }

  static DateTime getDay(DateTime datetime) {
    return DateTime(datetime.year, datetime.month, datetime.day);
  }

  static String getWeekRange(DateTime datetime) {
    var startOfWeek = datetime.subtract(Duration(days: datetime.weekday - 1));
    var endOfWeek = startOfWeek.add(Duration(days: 6));
    return DateFormat("d MMMM").format(startOfWeek) + " - " + DateFormat("d MMMM").format(endOfWeek);
  }

  static String getCompleteDateTimeString(DateTime datetime) {
    return DateFormat("dd-MM-yyyy", "it").format(datetime) + " alle " + DateFormat("HH:mm").format(datetime);
  }

  static String getMonthYear(DateTime datetime) {
    var string = DateFormat("MMMM yyyy", "it").format(datetime);
    return string.replaceRange(0, 1, string.substring(0, 1).toUpperCase());
  }
}
