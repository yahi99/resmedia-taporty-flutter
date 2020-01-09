import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/DriverBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TimeBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(UserBloc)
@BlocProvider.register(RestaurantBloc)
@BlocProvider.register(RestaurantsBloc)
@BlocProvider.register(RepositoryBloc)
@BlocProvider.register(SignUpMoreBloc)
@BlocProvider.register(CartBloc)
@BlocProvider.register(OrderBloc)
@BlocProvider.register(TurnBloc)
@BlocProvider.register(CalendarBloc)
@BlocProvider.register(TimeBloc)
@BlocProvider.register(DriverBloc)
abstract class Provider {}
