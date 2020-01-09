// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case UserBloc:
        {
          return BlocCache.getBlocInstance(
              "UserBloc", () => UserBloc.instance());
        }
      case RestaurantBloc:
        {
          return BlocCache.getBlocInstance(
              "RestaurantBloc", () => RestaurantBloc.instance());
        }
      case RestaurantsBloc:
        {
          return BlocCache.getBlocInstance(
              "RestaurantsBloc", () => RestaurantsBloc.instance());
        }
      case RepositoryBloc:
        {
          return BlocCache.getBlocInstance(
              "RepositoryBloc", () => RepositoryBloc.instance());
        }
      case SignUpMoreBloc:
        {
          return BlocCache.getBlocInstance(
              "SignUpMoreBloc", () => SignUpMoreBloc.instance());
        }
      case CartBloc:
        {
          return BlocCache.getBlocInstance(
              "CartBloc", () => CartBloc.instance());
        }
      case OrderBloc:
        {
          return BlocCache.getBlocInstance(
              "OrderBloc", () => OrderBloc.instance());
        }
      case TurnBloc:
        {
          return BlocCache.getBlocInstance(
              "TurnBloc", () => TurnBloc.instance());
        }
      case CalendarBloc:
        {
          return BlocCache.getBlocInstance(
              "CalendarBloc", () => CalendarBloc.instance());
        }
      case TimeBloc:
        {
          return BlocCache.getBlocInstance(
              "TimeBloc", () => TimeBloc.instance());
        }
      case DriverBloc:
        {
          return BlocCache.getBlocInstance(
              "DriverBloc", () => DriverBloc.instance());
        }
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case UserBloc:
        {
          BlocCache.dispose("UserBloc");
          break;
        }
      case RestaurantBloc:
        {
          BlocCache.dispose("RestaurantBloc");
          break;
        }
      case RestaurantsBloc:
        {
          BlocCache.dispose("RestaurantsBloc");
          break;
        }
      case RepositoryBloc:
        {
          BlocCache.dispose("RepositoryBloc");
          break;
        }
      case SignUpMoreBloc:
        {
          BlocCache.dispose("SignUpMoreBloc");
          break;
        }
      case CartBloc:
        {
          BlocCache.dispose("CartBloc");
          break;
        }
      case OrderBloc:
        {
          BlocCache.dispose("OrderBloc");
          break;
        }
      case TurnBloc:
        {
          BlocCache.dispose("TurnBloc");
          break;
        }
      case CalendarBloc:
        {
          BlocCache.dispose("CalendarBloc");
          break;
        }
      case TimeBloc:
        {
          BlocCache.dispose("TimeBloc");
          break;
        }
      case DriverBloc:
        {
          BlocCache.dispose("DriverBloc");
          break;
        }
    }
  }
}
