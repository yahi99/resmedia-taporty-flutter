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
      case LocationBloc:
        {
          return BlocCache.getBlocInstance(
              "LocationBloc", () => LocationBloc.instance());
        }
      case SupplierBloc:
        {
          return BlocCache.getBlocInstance(
              "SupplierBloc", () => SupplierBloc.instance());
        }
      case SupplierListBloc:
        {
          return BlocCache.getBlocInstance(
              "SupplierListBloc", () => SupplierListBloc.instance());
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
      case OrderListBloc:
        {
          return BlocCache.getBlocInstance(
              "OrderListBloc", () => OrderListBloc.instance());
        }
      case CheckoutBloc:
        {
          return BlocCache.getBlocInstance(
              "CheckoutBloc", () => CheckoutBloc.instance());
        }
      case ReviewBloc:
        {
          return BlocCache.getBlocInstance(
              "ReviewBloc", () => ReviewBloc.instance());
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
      case LocationBloc:
        {
          BlocCache.dispose("LocationBloc");
          break;
        }
      case SupplierBloc:
        {
          BlocCache.dispose("SupplierBloc");
          break;
        }
      case SupplierListBloc:
        {
          BlocCache.dispose("SupplierListBloc");
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
      case OrderListBloc:
        {
          BlocCache.dispose("OrderListBloc");
          break;
        }
      case CheckoutBloc:
        {
          BlocCache.dispose("CheckoutBloc");
          break;
        }
      case ReviewBloc:
        {
          BlocCache.dispose("ReviewBloc");
          break;
        }
    }
  }
}
