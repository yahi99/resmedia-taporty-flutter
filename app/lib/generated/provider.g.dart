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
      case OrdersBloc:
        {
          return BlocCache.getBlocInstance(
              "OrdersBloc", () => OrdersBloc.instance());
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
      case RequestsBloc:
        {
          return BlocCache.getBlocInstance(
              "RequestsBloc", () => RequestsBloc.instance());
        }
      case DriverRequestsBloc:
        {
          return BlocCache.getBlocInstance(
              "DriverRequestsBloc", () => DriverRequestsBloc.instance());
        }
      case RestaurantRequestsBloc:
        {
          return BlocCache.getBlocInstance("RestaurantRequestsBloc",
              () => RestaurantRequestsBloc.instance());
        }
      case UsersBloc:
        {
          return BlocCache.getBlocInstance(
              "UsersBloc", () => UsersBloc.instance());
        }
      case ControlBloc:
        {
          return BlocCache.getBlocInstance(
              "ControlBloc", () => ControlBloc.instance());
        }
      case ProductBloc:
        {
          return BlocCache.getBlocInstance(
              "ProductBloc", () => ProductBloc.instance());
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
      case OrdersBloc:
        {
          BlocCache.dispose("OrdersBloc");
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
      case RequestsBloc:
        {
          BlocCache.dispose("RequestsBloc");
          break;
        }
      case DriverRequestsBloc:
        {
          BlocCache.dispose("DriverRequestsBloc");
          break;
        }
      case RestaurantRequestsBloc:
        {
          BlocCache.dispose("RestaurantRequestsBloc");
          break;
        }
      case UsersBloc:
        {
          BlocCache.dispose("UsersBloc");
          break;
        }
      case ControlBloc:
        {
          BlocCache.dispose("ControlBloc");
          break;
        }
      case ProductBloc:
        {
          BlocCache.dispose("ProductBloc");
          break;
        }
    }
  }
}
