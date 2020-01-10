import 'dart:ui';

import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

class ColorTheme {
  static const RED = Color(0xFFd50000);
  static const ACCENT_RED = Color(0xFFff5131); // B71C1C
  static const BLUE = Color(0xFF1565c0);
  static const ACCENT_BLUE = Color(0xFF5e92f3); // 0F5DDB
  static const LIGHT_GREY = Color(0xFFE3E3E3);

  static const Map<OrderState, Color> STATE_COLORS = {
    OrderState.NEW: Color(0xFFFFC107),
    OrderState.ACCEPTED: Color(0xFF17A2B8),
    OrderState.MODIFIED: Color(0xFFFFC107),
    OrderState.CANCELLED: Color(0xFFDC3545),
    OrderState.PICKED_UP: Color(0xFF17A2B8),
    OrderState.DELIVERED: Color(0xFF28a745),
    OrderState.ARCHIVED: Color(0xFF6C757D),
    OrderState.READY: Color(0xFF17A2B8),
    OrderState.REFUSED: Color(0xFFDC3545),
  };
}
