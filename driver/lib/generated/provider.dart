import 'package:dash/dash.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderListBloc.dart';
import 'package:resmedia_taporty_driver/blocs/SuppliersBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(DriverBloc)
@BlocProvider.register(SuppliersBloc)
@BlocProvider.register(OrderBloc)
@BlocProvider.register(OrderListBloc)
@BlocProvider.register(DriverBloc)
abstract class Provider {}
