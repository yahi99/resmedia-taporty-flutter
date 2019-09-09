import 'package:dash/dash.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';

class FlavorBloc implements Bloc {
  Flavor flavor;

  @override
  dispose() {}

  void init(Flavor flavor) {
    this.flavor = flavor;
  }

  static Bloc instance() => FlavorBloc();

  static FlavorBloc of() => $Provider.of<FlavorBloc>();
}

enum Flavor {
  CLIENT,
  DRIVER,
}
