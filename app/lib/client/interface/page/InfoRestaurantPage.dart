import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/SeeReviewsScreen.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';

class InfoRestaurantPage extends StatelessWidget {
  final RestaurantModel model;
  final String address;

  InfoRestaurantPage({Key key, @required this.model, @required this.address}) : super(key: key);

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
                child: CachedNetworkImage(
                  imageUrl: model.imageUrl,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => SizedBox(
                    height: 30.0,
                    width: 30.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.grey)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        model.id,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headline,
                      ),
                      Text(
                        address,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.body1.copyWith(fontSize: 14),
                      ),
                      if (model.description != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                          child: Text(
                            model.description,
                            style: theme.textTheme.subhead,
                          ),
                        ),
                      if (model.averageReviews != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: InkWell(
                            child: Row(
                              children: <Widget>[
                                RatingBar.readOnly(
                                  initialRating: model.averageReviews,
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                  halfFilledIcon: Icons.star_half,
                                  isHalfAllowed: true,
                                  emptyColor: Colors.yellow,
                                  filledColor: Colors.yellow,
                                  halfFilledColor: Colors.yellow,
                                  size: 26,
                                ),
                                model.averageReviews != null ? Text(' ' + model.averageReviews.toString()) : Container(),
                              ],
                            ),
                            onTap: () {
                              EasyRouter.push(
                                context,
                                SeeReviewsScreen(
                                  model: model,
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Orario di oggi:\n",
                    style: theme.textTheme.body1.copyWith(fontSize: 15),
                  ),
                  TextSpan(
                    text: model.getTimetableString(),
                    style: theme.textTheme.body1.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
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
