import 'dart:async';

import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:easy_blocs/src/rxdart_extension/CacheStreamBuilder.dart';
import 'package:flutter/widgets.dart';


typedef Widget ValueChangedBuilder<V>(BuildContext context, V value);

/// Inutile lascia perdere
class CounterProductCart extends StatelessWidget {
  final String id;
  final String restaurantId;
  final String userId;
  final Stream<Cart> stream;
  final ValueChangedBuilder builder;

  const CounterProductCart({Key key,
    @required this.stream, @required this.id,@required this.userId, @required this.builder,@required this.restaurantId
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CacheStreamBuilder<Cart>(
      stream: stream,
      builder: (context, snapshot) {
        return builder(context, snapshot.data == null ? null :
          snapshot.data.getProduct(id,restaurantId,userId)?.countProducts??0);
      }
    );
  }
}