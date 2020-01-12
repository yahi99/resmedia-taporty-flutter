import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_stripe/src/StripeSourceModel.dart';
import 'package:easy_stripe/src/StripeProvider.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stripe_payment/stripe_payment.dart';

abstract class StripeManager {
  Stream<List<StripeSourceModel>> get outCards;

  Stream<StripeSourceModel> get outCard;

  Future<void> onAddPaymentCard();

  Future<void> inPickSource(String paymentCardId);
}

class DefaultStripeController implements Controller, StripeManager {
  final StripeProviderRule provider;
  String _userId;

  StreamSubscription userIdSub, cardsSub, cardSub;
  DefaultStripeController({
    @required publishableKey,
    @required Stream<String> outUserId,
    @required this.provider,
  })  : assert(provider != null),
        assert(publishableKey != null) {
    StripeSource.setPublishableKey(publishableKey);

    cardsController.onListen = () async {
      userIdSub = outUserId.listen((userId) {
        _userId = userId;
        cardsSub?.cancel();
        cardsSub = provider.getStripeSourcesModel(userId).listen((sources) {
          cardsController.add(sources);
        });
      });
    };

    cardController.onListen = () async {
      final cards = await outCards.first;
      if (cards.isNotEmpty) {
        final card = cards.reduce((currentCard, newCard) {
          if (newCard.lastUse == null) return currentCard;
          if (currentCard.lastUse == null) return newCard;
          return currentCard.lastUse.compareTo(newCard.lastUse) < 0 ? newCard : currentCard;
        });
        inPickSource(card.id);
      }
    };
  }

  @override
  void close() {
    cardsController.close();
    cardController.close();
    userIdSub?.cancel();
    cardsSub?.cancel();
    cardSub?.cancel();
  }

  final BehaviorSubject<List<StripeSourceModel>> cardsController = BehaviorSubject();
  Stream<List<StripeSourceModel>> get outCards => cardsController.stream;

  final BehaviorSubject<StripeSourceModel> cardController = BehaviorSubject();
  Stream<StripeSourceModel> get outCard => cardController.stream;

  Future<void> onAddPaymentCard() async {
    final sourceToken = await StripeSource.addSource();
    if (sourceToken == null) return;
    final paymentCardId = await provider.addStripeSourceModel(
        _userId,
        StripeSourceModel(
          token: sourceToken,
        ));
    await inPickSource(paymentCardId);
  }

  Future<void> inPickSource(String paymentCardId) async {
    cardSub = outCards.map((cards) => cards.firstWhere((card) => card.id == paymentCardId)).listen(cardController.add);
  }
}

mixin MixinStripeManager implements StripeManager {
  StripeManager get stripeManager;

  Stream<List<StripeSourceModel>> get outCards => stripeManager.outCards;

  Stream<StripeSourceModel> get outCard => stripeManager.outCard;

  Future<void> onAddPaymentCard() => stripeManager.onAddPaymentCard();
}
