import 'package:rxdart/rxdart.dart';

Stream customStreamPeriodic(Duration duration) {
  return ConcatStream([Stream.value(null), Stream.periodic(duration)]);
}
