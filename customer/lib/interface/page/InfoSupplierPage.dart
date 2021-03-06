import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:resmedia_taporty_core/core.dart';

class InfoSupplierPage extends StatelessWidget {
  final SupplierModel supplier;

  InfoSupplierPage({Key key, @required this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.8,
          child: CachedNetworkImage(
            imageUrl: supplier.imageUrl,
            fit: BoxFit.cover,
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
        Expanded(
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            supplier.name,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headline,
                          ),
                          Text(
                            supplier.address,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.body1.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (supplier.description != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                            child: Text(
                              supplier.description,
                              style: theme.textTheme.subhead,
                            ),
                          ),
                        if (supplier.rating != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  RatingBar.readOnly(
                                    initialRating: supplier.rating,
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    halfFilledIcon: Icons.star_half,
                                    isHalfAllowed: true,
                                    emptyColor: Colors.yellow,
                                    filledColor: Colors.yellow,
                                    halfFilledColor: Colors.yellow,
                                    size: 26,
                                  ),
                                  supplier.rating != null ? Text(' ' + supplier.rating.toString()) : Container(),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/supplierReviewList",
                                );
                              },
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Orario di oggi:\n",
                      style: theme.textTheme.body1.copyWith(fontSize: 15),
                    ),
                    TextSpan(
                      text: supplier.getTimetableString(),
                      style: theme.textTheme.body1.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/img/logotest.png',
                width: 96,
                alignment: Alignment.bottomRight,
                fit: BoxFit.fitWidth,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
