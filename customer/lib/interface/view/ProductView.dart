import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_customer/interface/widget/StepperButton.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

class ProductView extends StatelessWidget {
  final ProductModel model;
  final CartController cartController;

  ProductView({Key key, @required this.model, @required this.cartController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.white10,
          icon: Icons.close,
          onTap: () async {
            final userId = (await $Provider.of<UserBloc>().outUser.first).model.id;
            cartController.inRemove(model.id, model.supplierId, userId);
          },
        ),
      ],
      child: DefaultTextStyle(
        style: theme.textTheme.body1,
        child: SizedBox(
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
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
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Container(child: Text(model.name), width: MediaQuery.of(context).size.width * 2 / 5),
                      ),
                      Text('€ ${model.price.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
              CartStepperButton(
                model: model,
                cartController: cartController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartStepperButton extends StatelessWidget {
  final CartController cartController;
  final ProductModel model;

  const CartStepperButton({Key key, @required this.cartController, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserBloc user = $Provider.of<UserBloc>();
    return StreamBuilder<CartModel>(
      stream: cartController.outCart,
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final cart = snapshot.data;
        return StreamBuilder<FirebaseUser>(
          stream: user.outFirebaseUser,
          builder: (context, snap) {
            if (!snap.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            print(snap.data.uid);
            final product = cart.getProduct(model.id, model.supplierId, snap.data.uid);
            if (product != null && product.delete) {
              print(product.id + '  ' + product.delete.toString() + '  menu');
              cartController.inRemove(model.id, model.supplierId, snap.data.uid);
            }
            return StepperButton(
              direction: Axis.vertical,
              child: Text('${cart.getProduct(model.id, model.supplierId, snap.data.uid)?.quantity ?? 0}'),
              onDecrease: () {
                Vibration.vibrate(duration: 65);
                cartController.inDecrease(model.id, model.supplierId, snap.data.uid);
              },
              onIncrement: () {
                final prod = cart.getProduct(model.id, model.supplierId, snap.data.uid);
                final count = (prod != null) ? prod.quantity : 0;
                if (model.maxQuantity != 0 && model.maxQuantity <= count)
                  Toast.show('Limite massimo prodotti', context, duration: 3);
                else {
                  Vibration.vibrate(duration: 65);
                  cartController.inIncrement(model.id, model.supplierId, snap.data.uid, model.price, model.type);
                }
              },
            );
          },
        );
      },
    );
  }
}
