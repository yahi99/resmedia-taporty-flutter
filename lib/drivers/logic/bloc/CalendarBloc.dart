import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:dash/dash.dart';
import 'package:mobile_app/drivers/model/CalendarModel.dart';
import 'package:mobile_app/drivers/model/TurnModel.dart';
import 'package:mobile_app/generated/provider.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:rxdart/rxdart.dart';


class CalendarBloc implements Bloc {

  final _db = Database();

  @protected
  static CalendarBloc instance() => CalendarBloc();

  @protected
  @override
  void dispose() {
    _calendarControl.close();
  }

  PublishSubject<List<CalendarModel>> _calendarControl;
  Stream<List<CalendarModel>> get outCalendar => _calendarControl.stream;

  void setDate(DateTime now) {
    //final user=UserBloc.of();
    //final restUser=await user.outFirebaseUser.first;
    //final str=await _db.getDriverOrders(restUser.uid).first;
    print('lol');
    print(now.toIso8601String());
    _calendarControl = PublishController.catchStream(source: _db.getShifts(now));
  }

  void setShift(String startTime,String endTime,String day,List<String> users)async{
    final user=UserBloc.of();
    final restUser=await user.outFirebaseUser.first;
    users.add(restUser.uid);
    CloudFunctions.instance.getHttpsCallable(functionName: 'setShift').call({'startTime':startTime,'endTime':endTime,'day':day,
      'uid':restUser.uid,'month':month(DateTime.tryParse(day).month),'users':users
    });
  }

  String month(int month){
    if(month==1) return'JANUARY';
    if(month==2) return'FEBRUARY';
    if(month==3) return'MARCH';
    if(month==4) return'APRIL';
    if(month==5) return'MAY';
    if(month==6) return'JUNE';
    if(month==7) return'JULY';
    if(month==8) return'AUGUST';
    if(month==9) return'SEPTEMBER';
    if(month==10) return'OCTOBER';
    if(month==11) return'NOVEMBER';
    return'DECEMBER';
  }

  static CalendarBloc of() => $Provider.of<CalendarBloc>();
  void close() => $Provider.dispose<CalendarBloc>();
}
