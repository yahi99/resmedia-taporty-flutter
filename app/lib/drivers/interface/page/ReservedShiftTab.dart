import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/ShiftView.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/DriverBloc.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ReservedShiftTab extends StatefulWidget {
  ReservedShiftTab();

  @override
  _ReservedShiftTabState createState() => _ReservedShiftTabState();
}

class _ReservedShiftTabState extends State<ReservedShiftTab> with AutomaticKeepAliveClientMixin {
  var driverBloc = DriverBloc.of();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var theme = Theme.of(context);
    /*return Scaffold(
      body: (widget.model.length > 0)
          ? CustomScrollView(
              slivers: widget.model.keys.map<Widget>((nameGroup) {
                final products = widget.model[nameGroup];
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  sliver: SliverOrderVoid(
                    title: Text(translateMonthCategory(nameGroup)),
                    childCount: products.length,
                    builder: (_context, index) {
                      return InkWell(
                        child: TurnView(
                          model: products[index],
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            )
          : Padding(
              child: Text('Non ci sono turni.'),
              padding: EdgeInsets.all(8.0),
            ),
    );*/
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<List<ShiftModel>>(
          stream: driverBloc.outReservedShifts,
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
                return Column(
                  children: categorizedShifts.keys.map<Widget>(
                    (weekRange) {
                      final shifts = categorizedShifts[weekRange];
                      return StickyHeader(
                        header: Container(
                          color: ColorTheme.LIGHT_GREY,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              weekRange,
                              style: theme.textTheme.body1,
                            ),
                          ),
                        ),
                        content: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: ShiftView(
                                shift: shifts[index],
                              ),
                            );
                          },
                          separatorBuilder: (_, index) => Divider(height: 1, color: Colors.grey),
                          itemCount: shifts.length,
                        ),
                      );
                    },
                  ).toList(),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
