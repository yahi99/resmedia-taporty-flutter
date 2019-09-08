import 'package:easy_firebase/easy_firebase.dart';
import 'package:rxdart/rxdart.dart';


/// Sconsiglio l'uso di questa classe Prendetela come esempio
class ResolverControllerFs<M extends FirebaseModel> {

  ResolverControllerFs({List<M> models, Future<List<M>> resolver(Iterable<String> ids)}) :
  assert(models != null), assert(resolver != null) {
    _modelsController = PublishSubject(
      onListen: () async {
        _modelsController.add(await resolver(models.map((model) => model.id)));
      }
    );
  }

  PublishSubject<List<M>> _modelsController;
  Stream<List<M>> get outModels => _modelsController.stream;
}