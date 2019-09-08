import 'StripeSourceModel.dart';


mixin StripeProviderRule {

  Stream<List<StripeSourceModel>> getStripeSourcesModel(String userId) {
    return getStripeSources(userId)
        .map((rawSources) => rawSources.map((map) => StripeSourceModel.fromJson(map)).toList());
  }

  Stream<List<Map<String, dynamic>>> getStripeSources(String userId);



  Future<String> addStripeSourceModel(String userId, StripeSourceModel model) async {
    return await addStripeSource(userId, model.toJson());
  }

  Future<String> addStripeSource(String userId, Map<String, dynamic> data);
}