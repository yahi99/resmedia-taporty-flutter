// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// BlocProviderGenerator
// **************************************************************************

class $Provider extends Provider {
  static T of<T extends Bloc>() {
    switch (T) {
      case DriverBloc:
        {
          return BlocCache.getBlocInstance(
              "DriverBloc", () => DriverBloc.instance());
        }
      case CalendarBloc:
        {
          return BlocCache.getBlocInstance(
              "CalendarBloc", () => CalendarBloc.instance());
        }
      case OrderBloc:
        {
          return BlocCache.getBlocInstance(
              "OrderBloc", () => OrderBloc.instance());
        }
      case OrderListBloc:
        {
          return BlocCache.getBlocInstance(
              "OrderListBloc", () => OrderListBloc.instance());
        }
      case DriverBloc:
        {
          return BlocCache.getBlocInstance(
              "DriverBloc", () => DriverBloc.instance());
        }
      case ShiftBloc:
        {
          return BlocCache.getBlocInstance(
              "ShiftBloc", () => ShiftBloc.instance());
        }
    }
    return null;
  }

  static void dispose<T extends Bloc>() {
    switch (T) {
      case DriverBloc:
        {
          BlocCache.dispose("DriverBloc");
          break;
        }
      case CalendarBloc:
        {
          BlocCache.dispose("CalendarBloc");
          break;
        }
      case OrderBloc:
        {
          BlocCache.dispose("OrderBloc");
          break;
        }
      case OrderListBloc:
        {
          BlocCache.dispose("OrderListBloc");
          break;
        }
      case DriverBloc:
        {
          BlocCache.dispose("DriverBloc");
          break;
        }
      case ShiftBloc:
        {
          BlocCache.dispose("ShiftBloc");
          break;
        }
    }
  }
}
