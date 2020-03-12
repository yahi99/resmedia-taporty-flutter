import 'package:resmedia_taporty_core/src/models/SettingsModel.dart';
import 'package:resmedia_taporty_core/src/resources/DatabaseService.dart';

extension SettingsProviderExtension on DatabaseService {
  Stream<SettingsModel> getSettingsStream() {
    return firestore.collection('settings').document('settings').snapshots().map(SettingsModel.fromFirebase);
  }
}
