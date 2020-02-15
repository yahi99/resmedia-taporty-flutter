import 'dart:convert';

import 'package:resmedia_taporty_core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  Future<CartModel> getCart(String customerId, String supplierId) async {
    var sp = await SharedPreferences.getInstance();
    var string = sp.getString("cart_$customerId$supplierId");
    if (string == null || string == "") return CartModel.defaultValue();
    var map;
    try {
      map = jsonDecode(string);
    } catch (err) {
      await sp.remove("cart_$customerId$supplierId");
      return CartModel.defaultValue();
    }
    var cart;
    try {
      cart = CartModel.fromJson(map);
    } catch (err) {
      await sp.remove("cart_$customerId$supplierId");
      return CartModel.defaultValue();
    }

    return cart;
  }

  Future updateCart(String customerId, String supplierId, CartModel cart) async {
    var sp = await SharedPreferences.getInstance();
    await sp.setString("cart_$customerId$supplierId", jsonEncode(cart.toJson()));
  }

  Future setAuthProvider(String providerId) async {
    var sp = await SharedPreferences.getInstance();
    await sp.setString("auth_provider_id", providerId);
  }

  Future<String> getAuthProvider() async {
    var sp = await SharedPreferences.getInstance();
    return sp.getString("auth_provider_id");
  }
}
