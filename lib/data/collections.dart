
const USERS = 'users';


const RESTAURANTS = 'restaurants';
String restaurant(String rs) => RESTAURANTS+rs;
const PRODUCTS = 'products';

const TURNS='turns';
const DAYS='days';
const TIMES='times';


const _REVIEWS = '/reviews/';
String reviews(String rs) => restaurant(rs)+_REVIEWS;
String review(String rs, String rv) => reviews(rs)+rv;

const ORDERS = 'orders';

//TODO
const RESTAURANT_TYPES = '/types/';