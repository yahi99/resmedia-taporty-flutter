import 'dart:ui';

const USERS = 'users';

const RESTAURANTS = 'restaurants';

String restaurant(String rs) => RESTAURANTS + rs;
const PRODUCTS = 'products';

const TURNS = 'turns';
const DAYS = 'days';
const TIMES = 'times';

const _REVIEWS = '/reviews/';

String reviews(String rs) => restaurant(rs) + _REVIEWS;

String review(String rs, String rv) => reviews(rs) + rv;

const ORDERS = 'orders';

//TODO
const RESTAURANT_TYPES = '/types/';

const red = Color(0xFFd50000),
    accent_red = Color(0xFFff5131), // B71C1C
    blue = Color(0xFF1565c0),
    accent_blue = Color(0xFF5e92f3); // 0F5DDB
const STRIPE_PUBLIC_KEY = "pk_test_bI6Z2I2jFP7Tfjfm0AvIyWV500cS2fKdCO";
