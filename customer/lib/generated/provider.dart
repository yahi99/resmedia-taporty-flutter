import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_taporty_core/core.dart';

part 'provider.g.dart';

@BlocProvider.register(UserBloc)
@BlocProvider.register(SupplierBloc)
@BlocProvider.register(SuppliersBloc)
@BlocProvider.register(RepositoryBloc)
@BlocProvider.register(CartBloc)
@BlocProvider.register(OrderBloc)
@BlocProvider.register(DriverBloc)
abstract class Provider {}
