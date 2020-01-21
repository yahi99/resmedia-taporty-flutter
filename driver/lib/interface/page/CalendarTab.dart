import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekdayFormat;
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:toast/toast.dart';

class CalendarTab extends StatefulWidget {
  CalendarTab();

  @override
  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> with AutomaticKeepAliveClientMixin {
  DateTime _selectedDate;
  var suppliersBloc = $Provider.of<SuppliersBloc>();
  var driverBloc = $Provider.of<DriverBloc>();
  var _db = Database();

  @override
  void dispose() {
    super.dispose();
  }

  String _driverId;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTimeHelper.getDay(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCalendar(),
          _buildSelectedDate(),
          _buildShifts(),
        ],
      ),
    );
  }

  _buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel(
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        onDayPressed: (DateTime date, _) {
          if (date.compareTo(DateTime.now().subtract(Duration(days: 1))) <= 0 || date.difference(DateTime.now()).inDays > 28) return;
          this.setState(() => _selectedDate = date);
          if (_driverId != null) {
            suppliersBloc.fetchAvailableStartTimes(_selectedDate, _driverId);
          }
        },
        height: 400,
        todayButtonColor: ColorTheme.ACCENT_RED,
        weekendTextStyle: TextStyle(color: Colors.black),
        weekDayFormat: WeekdayFormat.narrow,
        firstDayOfWeek: 1,
        locale: Intl.defaultLocale,
        weekDayPadding: EdgeInsets.all(10),
        prevMonthDayBorderColor: Colors.grey,
        selectedDayButtonColor: ColorTheme.BLUE,
        selectedDateTime: _selectedDate,
        customDayBuilder: (
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day,
        ) {
          var textStyle = Theme.of(context).textTheme.body1.copyWith(fontSize: 12);
          if (day.compareTo(DateTime.now().subtract(Duration(days: 1))) <= 0 || day.difference(DateTime.now()).inDays > 28)
            textStyle = textStyle.copyWith(color: ColorTheme.LIGHT_GREY);
          else if (isSelectedDay || isToday)
            textStyle = textStyle.copyWith(color: Colors.white);
          else if (isNextMonthDay || isPrevMonthDay) textStyle = textStyle.copyWith(color: Colors.grey);
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${day.day}',
                  style: textStyle,
                  maxLines: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildSelectedDate() {
    return Container(
      width: double.infinity,
      color: ColorTheme.LIGHT_GREY,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          DateTimeHelper.getDateString(_selectedDate),
        ),
      ),
    );
  }

  _buildShifts() {
    var userBloc = $Provider.of<UserBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("Turni disponibili"),
        ),
        StreamBuilder<FirebaseUser>(
          stream: userBloc.outFirebaseUser,
          builder: (___, firebaseUserSnapshot) {
            if (firebaseUserSnapshot.hasData) {
              return StreamBuilder<List<DateTime>>(
                stream: suppliersBloc.outAvailableStartTimes,
                builder: (_, availableShiftListSnapshot) {
                  if (availableShiftListSnapshot.connectionState == ConnectionState.active) {
                    if (availableShiftListSnapshot.hasData && availableShiftListSnapshot.data.length > 0) {
                      return StreamBuilder<List<ShiftModel>>(
                        stream: driverBloc.outReservedShifts,
                        builder: (__, driverReservedShiftListSnapshot) {
                          if (driverReservedShiftListSnapshot.connectionState == ConnectionState.active) {
                            var availableShifts = availableShiftListSnapshot.data;
                            var reservedShifts = driverReservedShiftListSnapshot.data;

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (___, index) => Divider(height: 1, color: Colors.grey),
                              itemCount: availableShifts.length,
                              itemBuilder: (___, index) {
                                var alreadyReserved = false;
                                if (reservedShifts != null) if (reservedShifts.firstWhere((reservedShift) => reservedShift.startTime == availableShifts[index], orElse: () => null) != null)
                                  alreadyReserved = true;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(DateTimeHelper.getTimeString(availableShifts[index])),
                                                  Text(DateTimeHelper.getTimeString(availableShifts[index].add(Duration(minutes: 15)))),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 40.0,
                                              width: 2.0,
                                              color: Colors.grey,
                                            ),
                                            if (alreadyReserved) Padding(padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0), child: Text("Prenotato"))
                                          ],
                                        ),
                                      ),
                                      if (!alreadyReserved)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: FlatButton(
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            child: Text(
                                              'Conferma',
                                            ),
                                            textColor: Colors.black,
                                            color: ColorTheme.LIGHT_GREY,
                                            onPressed: () async {
                                              try {
                                                await _db.addShift(firebaseUserSnapshot.data.uid, availableShifts[index]);
                                                Toast.show("Turno confermato", context);
                                              } catch (e) {
                                                Toast.show("Errore inaspettato", context);
                                              }
                                            },
                                          ),
                                        ),
                                      if (alreadyReserved)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: FlatButton(
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            child: Text(
                                              'Annulla',
                                            ),
                                            textColor: Colors.black,
                                            color: ColorTheme.LIGHT_GREY,
                                            onPressed: () async {
                                              try {
                                                await _db.removeShift(firebaseUserSnapshot.data.uid, availableShifts[index]);
                                                Toast.show("Turno annullato", context);
                                              } catch (e) {
                                                Toast.show("Errore inaspettato", context);
                                              }
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                            height: 150,
                          );
                        },
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text("Non ci sono turni disponibili in questa giornata."),
                    );
                  }

                  if (_driverId == null) {
                    _driverId = firebaseUserSnapshot.data.uid;
                    suppliersBloc.fetchAvailableStartTimes(_selectedDate, _driverId);
                  }

                  return Container(
                    child: Center(child: CircularProgressIndicator()),
                    height: 150,
                  );
                },
              );
            }
            return Container(
              child: Center(child: CircularProgressIndicator()),
              height: 150,
            );
          },
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
