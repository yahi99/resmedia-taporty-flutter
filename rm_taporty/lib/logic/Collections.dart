import 'package:easy_firebase/easy_firebase.dart';


class RestaurantsCollection extends FirebaseCollection {
  final id = 'restaurants';
  final types='types';

  final $foods = const FoodsCollection();
  final $drinks = const DrinksCollection();

  const RestaurantsCollection();
}

class FoodsCollection extends FirebaseCollection {
  final id = 'foods';

  const FoodsCollection();
}
class DrinksCollection extends FirebaseCollection {
  final id = 'drinks';

  const DrinksCollection();
}


class TablesCollection extends FirebaseCollection {
  final id = 'tables';
  final users = 'users';
  final idRestaurant = 'idRestaurant';

  const TablesCollection();

  final $chairs = const ChairsCollection();
}

class ChairsCollection extends SubFirebaseCollection {
  final id = 'chairs';
  final products = 'products';

  const ChairsCollection([String before]) : super(before);
}