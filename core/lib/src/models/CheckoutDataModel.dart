import 'package:resmedia_taporty_core/src/models/ShiftModel.dart';

class CheckoutDataModel {
  String name, email, phone, cardId, customerId;
  ShiftModel selectedShift;

  int productCount; // TODO: Rimuovere dopo il refactoring delle classi Cart
}
