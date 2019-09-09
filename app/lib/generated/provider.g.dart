// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case FlavorBloc:
        {
          return BlocCache.getBlocInstance(
              "FlavorBloc", () => FlavorBloc.instance());
        }
      case UserBloc:
        {
          return BlocCache.getBlocInstance(
              "UserBloc", () => UserBloc.instance());
        }
      case FoodBloc:
        {
          return BlocCache.getBlocInstance(
              "FoodBloc", () => FoodBloc.instance());
        }
      case DrinkBloc:
        {
          return BlocCache.getBlocInstance(
              "DrinkBloc", () => DrinkBloc.instance());
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
      case TypesRestaurantBloc:
        {
          return BlocCache.getBlocInstance(
              "TypesRestaurantBloc", () => TypesRestaurantBloc.instance());
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
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case FlavorBloc:
        {
          BlocCache.dispose("FlavorBloc");
          break;
        }
      case UserBloc:
        {
          BlocCache.dispose("UserBloc");
          break;
        }
      case FoodBloc:
        {
          BlocCache.dispose("FoodBloc");
          break;
        }
      case DrinkBloc:
        {
          BlocCache.dispose("DrinkBloc");
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
      case TypesRestaurantBloc:
        {
          BlocCache.dispose("TypesRestaurantBloc");
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
    }
  }
}