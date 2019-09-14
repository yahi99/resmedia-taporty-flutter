import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/view/ProductViewRestaurant.dart';
import 'package:toast/toast.dart';

class MenuPage extends StatefulWidget implements WidgetRoute {
  final foods, drinks;

  static const ROUTE = "MenuPage";

  @override
  String get route => MenuPage.ROUTE;

  MenuPage({@required this.foods, @required this.drinks});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static const double SPACE_CELL = 8.0;
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _quantityKey = GlobalKey<FormFieldState>();
  final _categoryKey = GlobalKey<FormFieldState>();
  final _priceKey = GlobalKey<FormFieldState>();
  final _imageKey = GlobalKey<FormFieldState>();
  final _dropKey = GlobalKey();
  final StreamController<String> dropStream = StreamController<String>();

  String _path, _tempPath, cat;
  final values = ['Cibo', 'Bevande'];
  StreamController<String> _imgCtrl = StreamController<String>();
  final TextEditingController _imgTextController = TextEditingController();

  List<DropdownMenuItem> drop = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    drop.add(DropdownMenuItem(
      child: Text(values[0]),
      value: values[0],
    ));
    drop.add(DropdownMenuItem(
      child: Text(values[1]),
      value: values[1],
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  String translate(String cat) {
    if (cat == 'Cibo')
      return 'foods';
    else
      return 'drinks';
  }

  Future<String> uploadFile(String filePath) async {
    final ByteData bytes = await rootBundle.load(filePath);
    final Directory tempDir = Directory.systemTemp;
    final String fileName = filePath.split('/').last;
    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(file);
    final Uri downloadUrl = (await task.onComplete).uploadSessionUri;

    _path = downloadUrl.toString();
    print(_path);
    return _path;
  }

  void _addProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        final cls = theme.colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      child: TextFormField(
                        key: _nameKey,
                        decoration: InputDecoration(
                          hintText: 'Nome Prodotto',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo invalido';
                          } else if (value.length < 4)
                            return 'Deve contenere almeno 4 caratteri';
                          else if (value.length > 15)
                            return "Massimo 15 caratteri";
                          return null;
                        },
                      ),
                      padding: EdgeInsets.only(bottom: SPACE * 2),
                    ),
                    StreamBuilder<String>(
                      stream: _imgCtrl.stream,
                      builder: (ctx, img) {
                        if (img.hasData)
                          _imgTextController.value =
                              TextEditingValue(text: img.data);
                        else
                          _imgTextController.value = TextEditingValue(text: '');
                        return Padding(
                          child: TextField(
                            controller: _imgTextController,
                            decoration: InputDecoration(hintText: 'Immagine'),
                            onTap: () async {
                              ImagePicker.pickImage(source: ImageSource.gallery)
                                  .then((img) {
                                if (img != null) {
                                  _tempPath = img.path;
                                  _imgCtrl.add(_tempPath.split('/').last);
                                } else {
                                  Toast.show(
                                      'Devi scegliere un\'immagine!', context,
                                      duration: 3);
                                }
                              }).catchError((error) {
                                if (error is PlatformException) {
                                  if (error.code == 'photo_access_denied')
                                    Toast.show(
                                        'Devi garantire accesso alle immagini!',
                                        context,
                                        duration: 3);
                                }
                              });
                            },
                          ),
                          padding: EdgeInsets.only(bottom: SPACE * 2),
                        );
                      },
                    ),
                    /*FlatButton(
                    child: Text('Carica immagine'),
                    onPressed: ()async{
                      uploadFile(_tempPath);
                    },
                  ),*/
                    Padding(
                      child: TextFormField(
                        key: _quantityKey,
                        decoration: InputDecoration(
                          hintText: 'Quantità ordinabile',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          int temp = int.tryParse(value);
                          if (temp == null) {
                            return 'Campo invalido inserire un numero!';
                          }
                          return null;
                        },
                      ),
                      padding: EdgeInsets.only(bottom: SPACE * 2),
                    ),
                    Padding(
                      child: TextFormField(
                        key: _priceKey,
                        decoration: InputDecoration(
                          hintText: 'Prezzo',
                        ),
                        validator: (value) {
                          double temp = double.tryParse(value);
                          if (temp != null) {
                            return 'Campo invalido controllare che ci sia la virgola e non il punto!';
                          }
                          return null;
                        },
                      ),
                      padding: EdgeInsets.only(bottom: SPACE * 2),
                    ),
                    Padding(
                      child: TextFormField(
                        key: _categoryKey,
                        decoration: InputDecoration(
                          hintText: 'Categoria',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo invalido';
                          }
                          return null;
                        },
                      ),
                      padding: EdgeInsets.only(bottom: SPACE * 2),
                    ),
                    StreamBuilder<String>(
                      stream: dropStream.stream,
                      builder: (ctx, sp1) {
                        return Padding(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DropdownButton(
                                key: _dropKey,
                                value: (cat == null)
                                    ? values.elementAt(0)
                                    : sp1.data,
                                onChanged: (value) {
                                  print(value);
                                  cat = value;
                                  dropStream.add(value);
                                },
                                items: drop,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(bottom: SPACE * 2),
                        );
                      },
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (_tempPath != null) {
                            uploadFile(_tempPath).then((path) async {
                              Database().createRequestProduct(
                                  _nameKey.currentState.value.toString(),
                                  path,
                                  _categoryKey.currentState.value.toString(),
                                  _priceKey.currentState.value.toString(),
                                  _quantityKey.currentState.value.toString(),
                                  (await UserBloc.of().outUser.first)
                                      .model
                                      .restaurantId,
                                  translate((cat == null) ? values[0] : cat));
                              Toast.show(
                                  'Richiesta inviata correttamente!', context);
                            });
                          }
                        }
                      },
                      textColor: Colors.black,
                      child: Text(
                        "  Invia richiesta  ",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductsFoodDrinkBuilder(
        drinks: widget.drinks,
        foods: widget.foods,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addProduct(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ProductsFoodDrinkBuilder extends StatelessWidget {
  final List<FoodModel> foods;
  final List<DrinkModel> drinks;

  ProductsFoodDrinkBuilder(
      {Key key, @required this.foods, @required this.drinks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = List<Widget>();
    list.clear();
    for (int i = 0; i < drinks.length; i++) {
      var temp = drinks.elementAt(i);
      list.add(ProductViewRestaurant(
        model: temp,
      ));
    }
    for (int i = 0; i < foods.length; i++) {
      var temp = foods.elementAt(i);
      list.add(ProductViewRestaurant(
        model: temp,
      ));
    }
    return GroupsVoid(
      products: list,
    );
  }
}

class GroupsVoid extends StatelessWidget {
  final List<Widget> products;

  GroupsVoid({
    Key key,
    @required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverStickyHeader(
          header: Container(
            color: Colors.black12,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DefaultTextStyle(
                style: theme.textTheme.subtitle,
                child: Text((products.length == 0)
                    ? 'Non ci sono elementi nel listino'
                    : 'Listino'),
              ),
            ),
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: products[index],
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }
}
