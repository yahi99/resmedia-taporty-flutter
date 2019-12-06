import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/interface/screen/SeeReviewsScreen.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';

class InfoRestaurantPage extends StatelessWidget {
  final RestaurantModel model;
  final String address;

  InfoRestaurantPage({Key key, @required this.model,@required this.address}) : super(key: key);

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
                child: (model.img.startsWith('assets'))?Image.asset(
                  model.img,
                  fit: BoxFit.fitHeight,
                ):Image.network(
                  model.img,
                  fit: BoxFit.fitHeight,
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
                      address,
                      style: theme.textTheme.subhead,
                    ),
                    // Città - Indirizzo, civico
                    SizedBox(height: 16),
                    model.description!=null?Text(
                      model.description,
                      style: theme.textTheme.body1,
                      textAlign: TextAlign.justify,
                    ):Container(),
                    SizedBox(height: 16),
                    InkWell(
                      child:Row(
                        children: <Widget>[
                          Icon(Icons.star),
                          Icon(Icons.star),
                          model.averageReviews!=null?Text(' '+model.averageReviews.toString()):Container(),
                          Text(' Buono')
                        ],
                      ),
                      onTap: (){
                        EasyRouter.push(context,SeeReviewsScreen(model: model,));
                      },
                    ),
                    SizedBox(height: 16),
                    model.deliveryFee!=null?Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Costo consegna:\n'+ model.deliveryFee.toString()+'\n',
                        style: theme.textTheme.overline,
                      ),
                    ):Container(),
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
  }
}
