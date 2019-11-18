import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/ControlBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/DriverRequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/RequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/RestaurantRequestsBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/UsersBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TimeBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/CartBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/DrinkBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/FlavourBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/FoodBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/TypesRestaurantsBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';

part 'provider.g.dart';

@BlocProvider.register(FlavorBloc)
@BlocProvider.register(UserBloc)
@BlocProvider.register(FoodBloc)
@BlocProvider.register(DrinkBloc)
@BlocProvider.register(RestaurantBloc)
@BlocProvider.register(RestaurantsBloc)
@BlocProvider.register(TypesRestaurantBloc)
@BlocProvider.register(RepositoryBloc)
@BlocProvider.register(SignUpMoreBloc)
@BlocProvider.register(CartBloc)
@BlocProvider.register(OrdersBloc)
@BlocProvider.register(TurnBloc)
@BlocProvider.register(CalendarBloc)
@BlocProvider.register(TimeBloc)
@BlocProvider.register(RequestsBloc)
@BlocProvider.register(DriverRequestsBloc)
@BlocProvider.register(RestaurantRequestsBloc)
@BlocProvider.register(UsersBloc)
@BlocProvider.register(ControlBloc)
abstract class Provider {}
