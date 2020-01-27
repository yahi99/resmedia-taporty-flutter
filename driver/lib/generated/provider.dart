import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_driver/blocs/SuppliersBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(DriverBloc)
@BlocProvider.register(SuppliersBloc)
@BlocProvider.register(RepositoryBloc)
@BlocProvider.register(OrderBloc)
@BlocProvider.register(DriverBloc)
abstract class Provider {}
