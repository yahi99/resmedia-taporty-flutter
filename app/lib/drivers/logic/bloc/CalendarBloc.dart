import 'package:cloud_functions/cloud_functions.dart';
import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/drivers/model/CalendarModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:rxdart/rxdart.dart';

class CalendarBloc implements Bloc {
  final _db = Database();

  static CalendarBloc instance() => CalendarBloc();

  @protected
  @override
  void dispose() {
    if (_calendarControl != null) _calendarControl.close();
  }

  PublishSubject<List<CalendarModel>> _calendarControl;

  Stream<List<CalendarModel>> get outCalendar => _calendarControl.stream;

  void setDate(DateTime now) {
    _calendarControl = PublishController.catchStream(source: _db.getShifts(now));
  }

  Future setShift(String startTime, String endTime, String day, List<String> users) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    users.add(restUser.uid);
    print(users);
    //this chooses which restaurant to assign the order to...
    //chooses the one with less drivers for that time otherwise they all go into one
    //final restId=await Database().getRestId(day,startTime);
    //updates the general list and the specific restaurant list
    CloudFunctions.instance.getHttpsCallable(functionName: 'setShift').call({
      'startTime': startTime,
      'endTime': endTime,
      'day': day,
      //'restUsers':restId.free.add(restUser.uid),
      //'rid':restId.id,
      'year': DateTime.tryParse(day).year,
      'uid': restUser.uid,
      'month': month(DateTime.tryParse(day).month),
      'free': users,
      'isEmpty': false
    });
  }

  //TODO : delete shift + cancel user inside free users list and if is present in occupied list decide what to do
  void deleteShift(String startTime, String endTime, String day, List<String> users) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    users.add(restUser.uid);
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'setShift')
        .call({'startTime': startTime, 'endTime': endTime, 'day': day, 'uid': restUser.uid, 'month': month(DateTime.tryParse(day).month), 'users': users});
  }

  String month(int month) {
    if (month == 1) return 'JANUARY';
    if (month == 2) return 'FEBRUARY';
    if (month == 3) return 'MARCH';
    if (month == 4) return 'APRIL';
    if (month == 5) return 'MAY';
    if (month == 6) return 'JUNE';
    if (month == 7) return 'JULY';
    if (month == 8) return 'AUGUST';
    if (month == 9) return 'SEPTEMBER';
    if (month == 10) return 'OCTOBER';
    if (month == 11) return 'NOVEMBER';
    return 'DECEMBER';
  }

  static CalendarBloc of() => $Provider.of<CalendarBloc>();

  void close() => $Provider.dispose<CalendarBloc>();
}
