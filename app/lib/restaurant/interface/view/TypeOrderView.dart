import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/interface/page/DetailOrderRestaurantPage.dart'; // TODO
import 'package:url_launcher/url_launcher.dart';

class TypeOrderView extends StatelessWidget {
  final RestaurantOrderModel model;

  const TypeOrderView({
    Key key,
    this.model,
  }) : super(key: key);

  int totalProducts(List<ProductCart> cart) {
    int sum = 0;
    for (int i = 0; i < cart.length; i++) {
      sum += cart.elementAt(i).countProducts;
    }
    return sum;
  }

  String toDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return (dateTime.day.toString() +
        '/' +
        dateTime.month.toString() +
        '/' +
        dateTime.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var tt = theme.textTheme;
    final cart = Cart(products: model.products);
    return StreamBuilder<RestaurantOrderModel>(
      stream: Database().getRestaurantOrder(model.restaurantId, model.id),
      builder: (ctx, order) {
        if (!order.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        final model = order.data;
        final temp = model.endTime.split(':');
        final day = DateTime.parse(model.day);
        final time = DateTime(day.year, day.month, day.day,
            int.parse(temp.elementAt(0)), int.parse(temp.elementAt(1)));
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                EasyRouter.push(
                    context, DetailOrderRestaurantPage(model: model));
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 186,
                  minHeight: 48,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildRichText("Cliente: ", model.nominative, tt),
                        _buildRichText(
                            'Giorno di consegna: ', toDate(model.day), tt),
                        _buildRichText('Ora di consegna: ', model.endTime, tt),
                        _buildRichText('Numero di prodotti: ',
                            totalProducts(model.products).toString(), tt),
                        _buildRichText(
                            'Prezzo totale: ',
                            cart
                                    .getTotalPrice(
                                        cart.products,
                                        cart.products.first.userId,
                                        cart.products.first.restaurantId)
                                    .toString() +
                                ' €',
                            tt),
                        _buildRichText('Stato dell\'ordine: ',
                            translateOrderCategory(model.state), tt),
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: RaisedButton(
                              color: theme.colorScheme.secondaryVariant,
                              onPressed: () {
                                print(model.phone);
                                launch('tel:' + model.phone);
                              },
                              child: Text(
                                "Chiama",
                                style: tt.button,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildRichText(String title, String description, TextTheme tt) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          text: title,
          style: tt.subtitle,
          children: <TextSpan>[
            TextSpan(
              text: description,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}