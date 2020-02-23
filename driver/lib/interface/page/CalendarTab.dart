import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel, WeekdayFormat;
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/ShiftBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:toast/toast.dart';
import 'package:resmedia_taporty_driver/blocs/CalendarBloc.dart';

class CalendarTab extends StatefulWidget {
  CalendarTab();

  @override
  _CalendarTabState createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> with AutomaticKeepAliveClientMixin {
  var calendarBloc = $Provider.of<CalendarBloc>();
  var shiftBloc = $Provider.of<ShiftBloc>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: StreamBuilder<DateTime>(
        stream: calendarBloc.outSelectedDate,
        builder: (context, dateSnap) {
          var selectedDate = dateSnap.data;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCalendar(selectedDate),
              _buildSelectedDate(selectedDate),
              _buildShifts(),
            ],
          );
        },
      ),
    );
  }

  _buildCalendar(DateTime selectedDate) {
    return StreamBuilder<List<DateTime>>(
        stream: calendarBloc.outDateRange,
        builder: (context, rangeSnap) {
          if (!rangeSnap.hasData)
            return Container(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          var range = rangeSnap.data;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: CalendarCarousel(
              customGridViewPhysics: NeverScrollableScrollPhysics(),
              onDayPressed: (DateTime date, _) {
                if (date.compareTo(range[0]) < 0 || date.compareTo(range[1]) > 0) return;
                calendarBloc.setSelectedDate(date);
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
              selectedDateTime: selectedDate,
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
                if (day.compareTo(range[0]) < 0 || day.compareTo(range[1]) > 0)
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
        });
  }

  _buildSelectedDate(DateTime selectedDate) {
    return Container(
      width: double.infinity,
      color: ColorTheme.LIGHT_GREY,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          DateTimeHelper.getDateString(selectedDate),
        ),
      ),
    );
  }

  _buildShifts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text("Turni disponibili"),
        ),
        StreamBuilder<List<DateTime>>(
          stream: calendarBloc.outAvailableStartTimes,
          builder: (_, availableShiftListSnapshot) {
            return StreamBuilder<List<ShiftModel>>(
              stream: shiftBloc.outReservedShifts,
              builder: (__, driverReservedShiftListSnapshot) {
                if (driverReservedShiftListSnapshot.hasData && availableShiftListSnapshot.hasData) {
                  var availableShiftStartTimes = availableShiftListSnapshot.data;
                  var reservedShifts = driverReservedShiftListSnapshot.data;

                  if (availableShiftStartTimes.length > 0) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (___, index) => Divider(height: 1, color: Colors.grey),
                      itemCount: availableShiftStartTimes.length,
                      itemBuilder: (___, index) {
                        var alreadyReserved = false;
                        if (reservedShifts != null) if (reservedShifts.firstWhere((reservedShift) => reservedShift.startTime == availableShiftStartTimes[index], orElse: () => null) != null)
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
                                          Text(DateTimeHelper.getTimeString(availableShiftStartTimes[index])),
                                          Text(DateTimeHelper.getTimeString(availableShiftStartTimes[index].add(Duration(minutes: 15)))),
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
                                        await calendarBloc.addShift(availableShiftStartTimes[index]);
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
                                        await calendarBloc.removeShift(availableShiftStartTimes[index]);
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
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Non ci sono turni disponibili in questa giornata."),
                  );
                }
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                  height: 150,
                );
              },
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
