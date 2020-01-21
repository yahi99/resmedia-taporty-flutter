import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/DriverBloc.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/SupplierBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/SuppliersBloc.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(UserBloc)
@BlocProvider.register(SupplierBloc)
@BlocProvider.register(SuppliersBloc)
@BlocProvider.register(RepositoryBloc)
@BlocProvider.register(SignUpMoreBloc)
@BlocProvider.register(CartBloc)
@BlocProvider.register(OrderBloc)
@BlocProvider.register(DriverBloc)
abstract class Provider {}
