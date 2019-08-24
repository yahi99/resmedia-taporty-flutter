import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/drivers/interface/screen/AccountScreen.dart';
import 'package:mobile_app/interface/view/CardListView.dart';
import 'package:mobile_app/interface/widget/SearchBar.dart';
import 'package:mobile_app/logic/bloc/TypesRestaurantsBloc.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/interface/view/type_restaurant.dart';
import 'package:mobile_app/model/TypesRestaurantModel.dart';
import 'package:easy_route/easy_route.dart';


class HomeScreen extends StatefulWidget implements WidgetRoute {

  static const ROUTE = "HomeScreen";
  @override
  String get route => HomeScreen.ROUTE;


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double SPACE_CELL = 8.0;

  @override
  void initState() {
    super.initState();
  }



  void dispose() {
    TypesRestaurantBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorie'),
        backgroundColor: red,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              EasyRouter.push(context, AccountScreenDriver());
            },
          )
        ],
        bottom: SearchBar(),
      ),
      body: TypesRestaurantView(),
    );
  }
}


/*final typesRestaurant = [
  TypeRestaurant(img: "assets/img/home/ristoranti.png", title: "Ristoranti", restaurants: restaurants),
  TypeRestaurant(img: "assets/img/home/fastfood.png", title: "FastFood", restaurants: fastFood),
  TypeRestaurant(img: "assets/img/home/etnici.png", title: "Etnici", restaurants: etnici),
  TypeRestaurant(img: "assets/img/home/pizza.png", title: "Pizzeria", restaurants: pizza),
  TypeRestaurant(img: "assets/img/home/bisteccherie.jpg", title: "Bisteccherie", restaurants: beef),
  TypeRestaurant(img: "assets/img/home/japan.png", title: "Giapponese", restaurants: jap),
  TypeRestaurant(img: "assets/img/home/china.png", title: "Cinese", restaurants: china),
  TypeRestaurant(img: "assets/img/home/thai.png", title: "Thailandese", restaurants: thai),
];*/
class TypesRestaurantView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*CacheStreamBuilder<List<RestaurantModel>>(
    stream: _restaurantBloc.outRestaurants,
    builder: (context, snap) {
    if (!snap.hasData) return Center(child: CircularProgressIndicator(),);
    return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: snap.data.map<Widget>((_model) {
    return Expanded(child: InkWell(
    onTap: () => EasyRouter.push(context, RestaurantScreen(model: _model),),
    child: RestaurantCellView(model: _model,)),);
    }).toList()..insert(1, SizedBox(width: SPACE_CELL,),),
    );*/
    final TypesRestaurantBloc _typesRestaurantsBloc=TypesRestaurantBloc.of();
    return CacheStreamBuilder<List<TypesRestaurantModel>>(
        stream: _typesRestaurantsBloc.outRestaurants,
        builder: (context, snap)
    {
      if (!snap.hasData) return Center(child: CircularProgressIndicator(),);
      print(snap.hasData);
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CardListView(
            children: snap.data.map<Widget>((_model) {
              return TypeRestaurantView(model: _model,);
            }).toList(),
          ),
        ),
      );
    },
    );
  }
}