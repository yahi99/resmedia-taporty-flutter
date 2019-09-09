import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/AccountScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_taporty_flutter/interface/view/CardListView.dart';
import 'package:resmedia_taporty_flutter/interface/widget/SearchBar.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/main.dart';
import 'package:resmedia_taporty_flutter/interface/screen/HomeScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:easy_route/easy_route.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/model/TypesRestaurantModel.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';

/*final List<RestaurantModel> restaurants = [
  RestaurantModel(title: 'PRIMO PIATTO', img:'assets/img/home/ristoranti.png'),
  RestaurantModel(title: "L'ECONOMIA", img: 'assets/img/home/ristoranti.png'),
  RestaurantModel(title: "IL GOURMET", img: 'assets/img/home/ristoranti.png')

];*/

final List<RestaurantModel> restaurants = [
  RestaurantModel(title: 'da bepi', img: 'assets/img/home/ristoranti.png'),
];

final List<RestaurantModel> fastFood = [
  RestaurantModel(title: "BURGER", img: 'assets/img/home/fastfood.png'),
  RestaurantModel(title: "CHIPS&FISH", img: 'assets/img/home/fastfood.png'),
  RestaurantModel(title: "XXL", img: 'assets/img/home/fastfood.png'),
];

final List<RestaurantModel> etnici = [
  RestaurantModel(title: "ROSSO", img: 'assets/img/home/etnici.png'),
  RestaurantModel(title: "PICCANTISSIMO", img: 'assets/img/home/etnici.png'),
  RestaurantModel(title: "LO SPEZIATO", img: 'assets/img/home/etnici.png'),
];

final List<RestaurantModel> pizza = [
  RestaurantModel(title: "BELLA NAPOLI", img: 'assets/img/home/pizza.jpg'),
  RestaurantModel(title: "MARGHERITA", img: 'assets/img/home/pizza.jpg'),
  RestaurantModel(title: "POMODORO ROSSO", img: 'assets/img/home/pizza.jpg'),
];

final List<RestaurantModel> beef = [
  RestaurantModel(
      title: "ROAST HOUSE", img: 'assets/img/home/bisteccherie.jpg'),
  RestaurantModel(title: "BEST MEAT", img: 'assets/img/home/bisteccherie.jpg'),
  RestaurantModel(
      title: "BISTECCA AL SANGUE", img: 'assets/img/home/bisteccherie.jpg'),
];

final List<RestaurantModel> jap = [
  RestaurantModel(title: "ICHI NO SAMA", img: 'assets/img/home/japan.jpg'),
  RestaurantModel(title: "NI", img: 'assets/img/home/japan.jpg'),
  RestaurantModel(title: "SAN", img: 'assets/img/home/japan.jpg'),
];

final List<RestaurantModel> china = [
  RestaurantModel(title: "ORIENTE", img: 'assets/img/home/china.jpg'),
  RestaurantModel(title: "SOL LEVANTE", img: 'assets/img/home/china.jpg'),
  RestaurantModel(title: "DRAGONE ROSSO", img: 'assets/img/home/china.jpg'),
];

final List<RestaurantModel> thai = [
  RestaurantModel(title: "BAN", img: 'assets/img/home/thai.jpg'),
  RestaurantModel(title: "TRADIZIONALE", img: 'assets/img/home/thai.jpg'),
  RestaurantModel(title: "AL TEMPIO", img: 'assets/img/home/thai.jpg'),
];

class RestaurantListScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'RestaurantListScreen';

  String get route => ROUTE;
  final UserModel user;
  final Position position;
  final bool isAnonymous;

  RestaurantListScreen(
      {Key key,
      @required this.user,
      @required this.position,
      @required this.isAnonymous})
      : super(key: key);

  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  final double iconSize = 32;

  @override
  void dispose() {
    RestaurantsBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //_cartBloc.load(outRestaurants: RestaurantBloc.of().outRestaurant);
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = UserBloc.of();
    final RestaurantsBloc _restaurantsBloc = RestaurantsBloc.instance();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            userBloc.logout().then((onValue) {
              EasyRouter.pushAndRemoveAll(context, LoginScreen());
            });
          },
        ),
        title: Text('Ristoranti nella tua zona'),
        backgroundColor: red,
        centerTitle: true,
        actions: <Widget>[
          (widget.isAnonymous != null)
              ? (!widget.isAnonymous)
                  ? IconButton(
                      icon: Icon(Icons.account_circle),
                      onPressed: () {
                        EasyRouter.push(context, AccountScreenDriver());
                      },
                    )
                  : Container()
              : Container(),
        ],
        bottom: SearchBar(
          trailing: IconButton(
            alignment: Alignment.centerRight,
            icon: Icon(
              FontAwesomeIcons.slidersH,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
      ),
      body: CacheStreamBuilder<List<RestaurantModel>>(
          stream: _restaurantsBloc.outRestaurants,
          builder: (context, snap) {
            if (!snap.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CardListView(
                  children: snap.data.map<Widget>((_model) {
                    //final distance=new Distance();
                    var stream;
                    if (_model.getPos() != null && widget.position != null) {
                      final LatLng start = _model.getPos();
                      final LatLng end = LatLng(
                          widget.position.latitude, widget.position.longitude);
                      stream = userBloc.getDistance(start, end).asStream();
                      // TODO: Rimuovere l'else che permette un comportamento scorretto.
                    } else
                      stream = userBloc.getMockDistance().asStream();
                    return StreamBuilder<double>(
                        stream: stream,
                        builder: (ctx, snap) {
                          if (!snap.hasData) return Container();
                          // TODO: Ripristinare a tempo debito.
                          // if(snap.data/1000<_model.km) {
                          if (true) {
                            return InkWell(
                              onTap: () => EasyRouter.push(
                                context,
                                RestaurantScreen(
                                  position: widget.position,
                                  model: _model,
                                ),
                              ),
                              child: RestaurantView(
                                model: _model,
                              ),
                            );
                          } else
                            return Container();
                        });
                  }).toList(),
                ),
              ),
            );
          }),
    );
  }
}

class RestaurantView extends StatelessWidget {
  final RestaurantModel model;

  const RestaurantView({
    Key key,
    @required this.model,
  })  : assert(model != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    print(model.id);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Image.asset('${model.img}'),
          Container(
            color: Colors.black,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: DefaultTextStyle(
                style: TextStyle(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DefaultTextStyle(
                      style: TextStyle(fontSize: 20),
                      child: Text("${model.id}"),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.update,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("12:00 - 14:00"),
                            Text("18:00 - 22:00"),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
