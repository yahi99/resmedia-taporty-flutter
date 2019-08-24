import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:mobile_app/drivers/logic/bloc/CalendarBloc.dart';
import 'package:mobile_app/drivers/logic/bloc/TurnBloc.dart';
import 'package:mobile_app/logic/bloc/CartBloc.dart';
import 'package:mobile_app/logic/bloc/DrinkBloc.dart';
import 'package:mobile_app/logic/bloc/FlavourBloc.dart';
import 'package:mobile_app/logic/bloc/FoodBloc.dart';
import 'package:mobile_app/logic/bloc/RestaurantBloc.dart';
import 'package:mobile_app/logic/bloc/RestaurantsBloc.dart';
import 'package:mobile_app/logic/bloc/SignUpMoreBloc.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/logic/bloc/TypesRestaurantsBloc.dart';
import 'package:mobile_app/logic/bloc/OrdersBloc.dart';
import 'package:mobile_app/drivers/logic/bloc/TimeBloc.dart';

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
abstract class Provider {}