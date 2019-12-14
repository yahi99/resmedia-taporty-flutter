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
  final restBloc;

  static const ROUTE = "MenuPage";

  @override
  String get route => MenuPage.ROUTE;

  MenuPage({@required this.restBloc});

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
  final _dropCatKey=GlobalKey();

  StreamController<String> dropStream;
  StreamController<String> dropCatStream;
  StreamController<String> _imgCtrl;

  String _path, _tempPath, cat,category;
  List<DropdownMenuItem> dropMenu;
  final values = ['Cibo', 'Bevande'];
  final drinks = ['Vino','Caffetteria','Alcolici','Bevande'];
  final foods = ['Antipasti','Primi Piatti','Secondi Piatti','Menu di Mare','Menu di Terra','Contorni','Desert'];

  final TextEditingController _imgTextController = TextEditingController();

  List<DropdownMenuItem> drop = List<DropdownMenuItem>();
  List<DropdownMenuItem> dropFoods = List<DropdownMenuItem>();
  List<DropdownMenuItem> dropDrinks = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    dropStream = StreamController<String>.broadcast();
    dropCatStream = StreamController<String>.broadcast();
    _imgCtrl = StreamController<String>.broadcast();
    drop.add(DropdownMenuItem(
      child: Text(values[0]),
      value: values[0],
    ));
    drop.add(DropdownMenuItem(
      child: Text(values[1]),
      value: values[1],
    ));
    for(int i=0;i<drinks.length;i++){
      dropDrinks.add(DropdownMenuItem(
        child: Text(drinks[i]),
        value: drinks[i],
      ));
    }
    for(int i=0;i<foods.length;i++){
      dropFoods.add(DropdownMenuItem(
        child: Text(foods[i]),
        value: foods[i],
      ));
    }
    dropMenu=dropFoods;
  }

  @override
  void dispose() {
    super.dispose();
    dropStream.close();
    dropCatStream.close();
    _imgCtrl.close();
  }

  String translate(String cat) {
    if (cat == 'Cibo')
      return 'foods';
    else
      return 'drinks';
  }
  String translateCat(String cat){
    if(cat=='Vino') return 'WINE';
    else if(cat=='Caffetteria') return 'COFFEE';
    else if(cat=='Alcolici') return 'ALCOHOLIC';
    else if(cat=='Bevande') return 'DRINK';
    else if(cat=='Antipasti') return 'APPETIZER';
    else if(cat=='Primi Piatti') return 'FIRST_COURSES';
    else if(cat=='Secondi Piatti') return 'MAIN_COURSES';
    else if(cat=='Menu di Mare') return 'SEAFOOD_MENU';
    else if(cat=='Menu di Terra') return 'MEAT_MENU';
    else if(cat=='Contorni') return 'SIDE_DISH';
    return 'DESERT';
  }

  Future<String> uploadFile(String filePath) async {
    final Uint8List bytes = File(filePath).readAsBytesSync();
    final Directory tempDir = Directory.systemTemp;
    final String fileName = filePath.split('/').last;
    final File file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(bytes, mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(file);
    final Uri downloadUrl = (await task.onComplete).uploadSessionUri;

    //_path = downloadUrl.toString();
    _path=(await ref.getDownloadURL());
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
            content: Container(
              child:
                ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
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
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: _imgTextController,
                                    decoration: InputDecoration(hintText: 'Immagine'),
                                    onTap: () async {
                                      ImagePicker.pickImage(source: ImageSource.gallery)
                                          .then((img) {
                                        if (img != null) {
                                          print(img.path);
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
                                  (img.hasData)?Padding(child:Image.file(File(_tempPath)),padding:EdgeInsets.all(SPACE)):Container(),
                                ],
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
                              //var count=int.tryParse(value).toDouble();
                              //print(temp);
                              //if(int.tryParse(value).toDouble()!=null) temp=int.tryParse(value).toDouble();
                              if (temp == null) {
                                //print(temp);
                                return 'Campo invalido controllare che ci sia la virgola e non il punto!';
                              }
                              return null;
                            },
                          ),
                          padding: EdgeInsets.only(bottom: SPACE * 2),
                        ),
                        /*Padding(
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
                    ),*/
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
                                      if(value=='Cibo'){
                                        category=foods.elementAt(0);
                                        dropMenu=dropFoods;
                                        dropCatStream.add(foods.elementAt(0));
                                      }
                                      else {
                                        category=drinks.elementAt(0);
                                        dropMenu=dropDrinks;
                                        dropCatStream.add(drinks.elementAt(0));
                                      }
                                    },
                                    items: drop,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(bottom: SPACE * 2),
                            );
                          },
                        ),
                        StreamBuilder<String>(
                          stream: dropCatStream.stream,
                          builder: (ctx, sp1) {
                            /*if(category==null || category=='Cibo')
                        return Padding(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DropdownButton(
                                key: _dropCatKey,
                                value: (category == null || !sp1.hasData)
                                    ? drinks.elementAt(0)
                                    : sp1.data,
                                onChanged: (value) {
                                  print(value);
                                  category = value;
                                  dropCatStream.add(value);
                                },
                                items: dropFoods,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.only(bottom: SPACE * 2),
                        );*/
                            return Padding(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  DropdownButton(
                                    key: _dropCatKey,
                                    value: (category == null || !sp1.hasData)
                                        ? foods.elementAt(0)
                                        : sp1.data,
                                    onChanged: (value) {
                                      print(value);
                                      category = value;
                                      dropCatStream.add(value);
                                    },
                                    items: dropMenu,
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
                                if(_tempPath.split('.').last!='jpg'){
                                  Toast.show('Il formato dell\'immagine deve essere .jpg', context,duration: 3);
                                }
                                else uploadFile(_tempPath).then((path) async {
                                  Database().createRequestProduct(
                                      _nameKey.currentState.value.toString(),
                                      path,
                                      translateCat((category==null)?foods[0]:category),
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
                      ],),
                    ),
                  ],
                ),
              height: 400,
              width: 200,
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DrinkModel>>(
        stream: widget.restBloc.outDrinks,
        builder: (context, drinks) {
          return StreamBuilder<List<FoodModel>>(
              stream: widget.restBloc.outFoods,
              builder: (context, foods) {
                if(foods.hasData && drinks.hasData){
                  return Scaffold(
                    appBar: AppBar(
                    ),
                    body: ProductsFoodDrinkBuilder(
                      drinks: drinks.data,
                      foods: foods.data,
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
                return Center(child: CircularProgressIndicator(),);
              }
          );
        }
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
      if(!temp.isDisabled) list.add(ProductViewRestaurant(
        model: temp,
      ));
    }
    for (int i = 0; i < foods.length; i++) {
      var temp = foods.elementAt(i);
      if(!temp.isDisabled) list.add(ProductViewRestaurant(
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
