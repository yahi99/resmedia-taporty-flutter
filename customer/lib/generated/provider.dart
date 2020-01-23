import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SuppliersBloc.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/OrderBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(UserBloc)
@BlocProvider.register(SupplierBloc)
@BlocProvider.register(SuppliersBloc)
@BlocProvider.register(RepositoryBloc)
@BlocProvider.register(CartBloc)
@BlocProvider.register(OrderBloc)
abstract class Provider {}
