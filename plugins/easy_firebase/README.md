# easy_firebase

A new Flutter project.

## Firebase User Modelling

- Definisci il tuo _UserMode_ e la tua classe _User_

``` dart
@JsonSerializable(anyMap: true, explicitToJson: true)
class UserModel extends UserFirebaseModel {
  final String nominative;
  final String email;

  UserModel({
    String path,
    String fcmToken,
    @required this.nominative,
    @required this.email,
  }) : super(path: path, fcmToken: fcmToken);

  static UserModel fromJson(Map json) => _$UserModelFromJson(json);
  static UserModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}


class User extends UserBase<UserModel> {
  User({FirebaseUser userFb, UserModel model}) : super(userFb, model);
}
```
