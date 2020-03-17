import 'package:dash/dash.dart';
import 'package:resmedia_taporty_driver/blocs/CalendarBloc.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderListBloc.dart';
import 'package:resmedia_taporty_driver/blocs/ShiftBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(DriverBloc)
@BlocProvider.register(CalendarBloc)
@BlocProvider.register(OrderBloc)
@BlocProvider.register(OrderListBloc)
@BlocProvider.register(DriverBloc)
@BlocProvider.register(ShiftBloc)
abstract class Provider {}
