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
      case SuppliersBloc:
        {
          return BlocCache.getBlocInstance(
              "SuppliersBloc", () => SuppliersBloc.instance());
        }
      case RepositoryBloc:
        {
          return BlocCache.getBlocInstance(
              "RepositoryBloc", () => RepositoryBloc.instance());
        }
      case OrderBloc:
        {
          return BlocCache.getBlocInstance(
              "OrderBloc", () => OrderBloc.instance());
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
      case DriverBloc:
        {
          BlocCache.dispose("DriverBloc");
          break;
        }
      case SuppliersBloc:
        {
          BlocCache.dispose("SuppliersBloc");
          break;
        }
      case RepositoryBloc:
        {
          BlocCache.dispose("RepositoryBloc");
          break;
        }
      case OrderBloc:
        {
          BlocCache.dispose("OrderBloc");
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
