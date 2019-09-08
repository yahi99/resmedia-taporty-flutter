import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/src/database/Models.dart';


Future<List<DocumentSnapshot>> resolver(List<DocumentReference> ls) async {
  List<DocumentSnapshot> docs = List();
  ls.forEach((ref) async {
    docs.add(await ref.get());
  });
  return docs;
}

typedef T DocumentResolver<T>(Map<dynamic, dynamic> json);

final Map<Type, DocumentResolver> _documentResolvers = {};

void registerDocumentResolver<T>(DocumentResolver<T> resolver) {
  _documentResolvers[T] = resolver;
}






typedef Future<T> ResolverDocumentPath<T>(List<FirebaseModel> models);






typedef O TypeBuilder<O>(Map<dynamic, dynamic> map);

final Map<Type, TypeBuilder> jsonModelBuilders = {};

void registerFromJson<O>(Type type, TypeBuilder<O> typeBuilder) {
  jsonModelBuilders[type] = typeBuilder;
}

dynamic resolverFromJson(Type type, Map<dynamic, dynamic> map) {
  return jsonModelBuilders[type](map);
}



/*final Map<Type, JsonBuilder> _jsonBuilders = {};

typedef Map<String, dynamic> JsonBuilder<O>(O object);

registerToJson<O>(Type type, JsonBuilder<O> typeBuilder) {
  _jsonBuilders[type] = typeBuilder;
}*/

