import 'package:dash/dash.dart';
import 'package:resmedia_taporty_customer/blocs/LocationBloc.dart';
import 'package:resmedia_taporty_customer/blocs/OrderListBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierListBloc.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/OrderBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(UserBloc)
@BlocProvider.register(LocationBloc)
@BlocProvider.register(SupplierBloc)
@BlocProvider.register(SupplierListBloc)
@BlocProvider.register(CartBloc)
@BlocProvider.register(OrderBloc)
@BlocProvider.register(OrderListBloc)
abstract class Provider {}
