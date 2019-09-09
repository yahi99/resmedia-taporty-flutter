import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';

class InfoRestaurantPage extends StatelessWidget {
  final RestaurantModel model;

  InfoRestaurantPage({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1.5,
                child: Image.asset(
                  'assets/img/food/meat.jpg',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: SPACE, horizontal: SPACE * 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      model.id,
                      style: theme.textTheme.headline,
                    ),
                    // Nome del ristorante
                    Text(
                      "Assisi - via Mario Rossi, 21",
                      style: theme.textTheme.subhead,
                    ),
                    // Città - Indirizzo, civico
                    SizedBox(height: 16),
                    Text(
                      'Molto Buona.',
                      style: theme.textTheme.body1,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Costo consegna:\n 1.90 \n',
                        style: theme.textTheme.overline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(SPACE),
            child: Image.asset(
              'assets/img/logotest.png',
              width: 96,
              alignment: Alignment.bottomRight,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ],
    );
    /*return Container(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('restaurants')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children: snapshot.data.documents
                      .map((DocumentSnapshot document) {
                    return Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              AspectRatio(
                                aspectRatio: 1.5,
                                child: Image.asset(
                                  'assets/img/food/meat.jpg', fit: BoxFit.fill,),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: SPACE, horizontal: SPACE * 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(document['id'], style: theme.textTheme.headline,),
                                    // Nome del ristorante
                                    Text("Assisi - via Mario Rossi, 21",
                                      style: theme.textTheme.subhead,),
                                    // Città - Indirizzo, civico
                                    SizedBox(height: 16),
                                    Text(
                                      document['description'],
                                      style: theme.textTheme.body1,
                                      textAlign: TextAlign.justify,
                                    ),
                                    SizedBox(height: 16),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Costo consegna:\n 1.90 euro\n',
                                        style: theme.textTheme.overline,),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(SPACE),
                            child: Image.asset('assets/img/logotest.png', width: 96,
                              alignment: Alignment.bottomRight,
                              fit: BoxFit.fitWidth,),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
                /*return Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 1.5,
                            child: Image.asset(
                              'assets/img/food/meat.jpg', fit: BoxFit.fill,),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: SPACE, horizontal: SPACE * 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(document['id'], style: theme.textTheme.headline,),
                                // Nome del ristorante
                                Text("Assisi - via Mario Rossi, 21",
                                  style: theme.textTheme.subhead,),
                                // Città - Indirizzo, civico
                                SizedBox(height: 16),
                                Text(
                                  model.description,
                                  style: theme.textTheme.body1,
                                  textAlign: TextAlign.justify,
                                ),
                                SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Costo consegna:\n' +
                                      model.priceRating.toString() + '\n',
                                    style: theme.textTheme.overline,),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(SPACE),
                        child: Image.asset('assets/img/logotest.png', width: 96,
                          alignment: Alignment.bottomRight,
                          fit: BoxFit.fitWidth,),
                      ),
                    ),
                  ],
                );*/
            }
          },
        ));*/
  }
}
