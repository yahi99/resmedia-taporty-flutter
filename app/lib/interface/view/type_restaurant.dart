import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:mobile_app/interface/screen/RestaurantListScreen.dart';
import 'package:mobile_app/model/TypesRestaurantModel.dart';
import 'package:easy_route/easy_route.dart';

class TypeRestaurantView extends StatelessWidget {
  final TypesRestaurantModel model;

  const TypeRestaurantView({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textButtonTheme = theme.textTheme.title.copyWith(color: Colors.white);
    /*final _restaurantsBloc = RestaurantsBloc.instance(model.id);
    return CacheStreamBuilder<List<RestaurantModel>>(
        stream: _restaurantsBloc.outRestaurants,
        builder: (context, snap) {
          return Stack(
              alignment: Alignment.center,
              children: snap.data.map<Widget>((_model) {
                AspectRatio(
                  aspectRatio: 2,
                  child: Image.asset(_model.img, fit: BoxFit.fill,),
                );
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 186,
                      minHeight: 48,
                    ),
                    child: RaisedButton(
                      onPressed: () {
                        EasyRouter.push(context,
                          RestaurantListScreen(
                            title: _model.title, models: _model,),);
                      },
                      child: Text(_model.title, style: textButtonTheme,),
                    ),
                  ),

                );
              }
              ),
          );
        }
    );*/
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 2,
          child: Image.asset(
            model.img,
            fit: BoxFit.fill,
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 186,
              minHeight: 48,
            ),
            child: RaisedButton(
              onPressed: () {
                /*EasyRouter.push(context,
                  RestaurantListScreen(
                    model: model,),);*/
              },
              child: Text(
                model.id,
                style: textButtonTheme,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
