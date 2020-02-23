import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/blocs/ShiftBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:resmedia_taporty_driver/interface/view/ShiftView.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ReservedShiftTab extends StatefulWidget {
  ReservedShiftTab();

  @override
  _ReservedShiftTabState createState() => _ReservedShiftTabState();
}

class _ReservedShiftTabState extends State<ReservedShiftTab> with AutomaticKeepAliveClientMixin {
  var driverBloc = $Provider.of<DriverBloc>();
  var shiftBloc = $Provider.of<ShiftBloc>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = Theme.of(context);
    return Scaffold(
      body: StreamBuilder<List<ShiftModel>>(
        stream: shiftBloc.outReservedShifts,
        builder: (_, reservedShiftListSnapshot) {
          if (reservedShiftListSnapshot.connectionState == ConnectionState.active) {
            if (reservedShiftListSnapshot.hasData && reservedShiftListSnapshot.data.length > 0) {
              List<String> weekRanges = [];
              var currentDate = reservedShiftListSnapshot.data.first.startTime;
              var lastWeek = DateTimeHelper.getWeekRange(reservedShiftListSnapshot.data.last.startTime);
              do {
                weekRanges.add(DateTimeHelper.getWeekRange(currentDate));
                currentDate = currentDate.add(Duration(days: 7));
              } while (weekRanges.last != lastWeek);
              weekRanges.add(lastWeek);
              var categorizedShifts = categorized<String, ShiftModel>(weekRanges, reservedShiftListSnapshot.data, (shift) => DateTimeHelper.getWeekRange(shift.startTime));
              return SingleChildScrollView(
                child: Column(
                  children: categorizedShifts.keys.map<Widget>(
                    (weekRange) {
                      final shifts = categorizedShifts[weekRange];
                      return StickyHeader(
                        header: Container(
                          color: ColorTheme.LIGHT_GREY,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            child: Center(
                              child: Text(
                                weekRange,
                                style: theme.textTheme.body1,
                              ),
                            ),
                          ),
                        ),
                        content: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ShiftView(
                              shift: shifts[index],
                            );
                          },
                          separatorBuilder: (_, index) => Divider(height: 1, color: Colors.grey),
                          itemCount: shifts.length,
                        ),
                      );
                    },
                  ).toList(),
                ),
              );
            }
            return Padding(
              child: Text('Non ci sono turni.'),
              padding: EdgeInsets.all(8.0),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
