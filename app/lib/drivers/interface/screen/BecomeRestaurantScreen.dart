import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:toast/toast.dart';

class BecomeRestaurantScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'AccountScreenDriver';

  String get route => ROUTE;

  @override
  State<BecomeRestaurantScreen> createState() => new NewDriverState();
}

class NewDriverState extends State<BecomeRestaurantScreen> {
  static final String _key = 'AIzaSyAmJyflDR6W10z738vMkLz9Oham51HR790';

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _key);

  TextEditingController _controller = TextEditingController();

  final TextEditingController _imgTextController = TextEditingController();

  var isValid = false;
  Position pos;
  String address;

  final _formKey = new GlobalKey<FormState>();
  final _ragKey = new GlobalKey<FormFieldState>();
  final _ivaKey = new GlobalKey<FormFieldState>();
  final _indKey = new GlobalKey<FormFieldState>();
  final _eseKey = new GlobalKey<FormFieldState>();
  final _prodKey = new GlobalKey<FormFieldState>();
  final _copKey = new GlobalKey<FormFieldState>();

  FocusNode _ragNode;
  FocusNode _ivaNode;
  FocusNode _indNode;
  FocusNode _eseNode;
  FocusNode _prodNode;
  FocusNode _copNode;
  FocusNode _imgNode;

  // ignore: close_sinks
  StreamController geo;

  StreamController<String> _imgCtrl;

  String _path, _tempPath;

  Future<String> uploadFile(String filePath) async {
    final ByteData bytes = await rootBundle.load(filePath);
    final Directory tempDir = Directory.systemTemp;
    final String fileName = filePath.split('/').last;
    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(file);
    final Uri downloadUrl = (await task.onComplete).uploadSessionUri;

    //_path = downloadUrl.toString();
    _path = (await ref.getDownloadURL());
    print(_path);
    return _path;
  }

  void _focusNodePlaces() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p =
        await PlacesAutocomplete.show(context: context, apiKey: _key);
    displayPrediction(p);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      //var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      pos = Position(latitude: lat, longitude: lng);

      address = p.description;

      isValid = true;

      geo.sink.add(address);
    }
  }

  @override
  void initState() {
    _ragNode = new FocusNode();
    _ivaNode = new FocusNode();
    _indNode = new FocusNode();
    _eseNode = new FocusNode();
    _prodNode = new FocusNode();
    _imgNode = new FocusNode();
    geo = StreamController<String>.broadcast();
    _imgCtrl = StreamController<String>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    _ragNode.dispose();
    _ivaNode.dispose();
    _indNode.dispose();
    _eseNode.dispose();
    _prodNode.dispose();
    _imgNode.dispose();
    geo.close();
    _imgCtrl.close();
    super.dispose();
  }

  void _upgrade(String uid, BuildContext context) {
    if (_formKey.currentState.validate()) {
      if(pos!=null && address!=null) {
        if (_tempPath != null) {
          if(_tempPath.split('.').last!='jpg'){
            Toast.show('Il formato dell\'immagine deve essere .jpg', context,duration: 3);
          }
          else uploadFile(_tempPath).then((path) async {
            Database().upgradeToVendor(uid: uid,pos: pos,
                img: path,cop: double.parse(_copKey.currentState.value),rid: _ragKey.currentState.value,
                ragSociale: _ragKey.currentState.value,partitaIva: _ivaKey.currentState.value,
                address: _indKey.currentState.value,eseType: _eseKey.currentState.value,
                prodType: _prodKey.currentState.value).then((value){
              Toast.show('Richiesta andata a buon fine!', context,duration: 3);
            });
          });
        }
      }
    }
  }

  void _changeFocus(
      BuildContext context, FocusNode currentNode, FocusNode nextNode) {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = UserBloc.of();
    return Scaffold(
      appBar: AppBar(
        title: Text("Diventa un Ristoratore"),
      ),
      body: StreamBuilder<User>(
        stream: user.outUser,
        builder: (ctx, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      child: Text(
                        snap.data.model.nominative,
                        style: theme.textTheme.subhead,
                      ),
                      padding: EdgeInsets.all(8.0),
                    ),
                    Padding(
                      child: Text(
                        snap.data.model.email,
                        style: theme.textTheme.subhead,
                      ),
                      padding: EdgeInsets.all(8.0),
                    ),
                    Form(
                      autovalidate: false,
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            child: TextFormField(
                              key: _ragKey,
                              focusNode: _ragNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _ragNode, _ivaNode),
                              validator: (value) {
                                if (value.length ==0) {
                                  return 'Inserisci ragione sociale';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Ragione sociale",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _ivaKey,
                              focusNode: _ivaNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                _changeFocus(context, _ivaNode, _indNode);
                                _focusNodePlaces();
                                _changeFocus(context, _indNode, _copNode);
                              },
                              decoration: InputDecoration(
                                hintText: "Partita iva",
                              ),
                              validator: (value) {
                                if (value.length == 0) {
                                  return 'Inserisci partita iva';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          StreamBuilder<String>(
                            stream: geo.stream,
                            builder: (ctx, snap) {
                              if (snap.hasData)
                                _controller.value =
                                    TextEditingValue(text: snap.data);
                              return Padding(
                                child: TextFormField(
                                  controller: _controller,
                                  onTap: _focusNodePlaces,
                                  key: _indKey,
                                  focusNode: _indNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) =>
                                      _changeFocus(context, _indNode, _copNode),
                                  decoration: InputDecoration(
                                    hintText: "Indirizzo",
                                  ),
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return 'Inserisci indirizzo';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.text,
                                ),
                                padding: EdgeInsets.all(8.0),
                              );
                            },
                          ),
                          Padding(
                            child: TextFormField(
                              key: _copKey,
                              focusNode: _copNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) async {
                                _copNode.unfocus();
                                ImagePicker.pickImage(
                                        source: ImageSource.gallery)
                                    .then((img) {
                                  if (img != null) {
                                    _tempPath = img.path;
                                    _imgCtrl.add(_tempPath.split('/').last);
                                    FocusScope.of(context).requestFocus(_eseNode);
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
                              decoration: InputDecoration(
                                hintText: "Copertura in Km",
                              ),
                              validator: (value) {
                                if (value.length == 0) {
                                  return 'Inserisci copertura';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          StreamBuilder<String>(
                            stream: _imgCtrl.stream,
                            builder: (ctx, img) {
                              if (img.hasData)
                                _imgTextController.value =
                                    TextEditingValue(text: img.data);
                              else
                                _imgTextController.value =
                                    TextEditingValue(text: '');
                              return Padding(
                                child: TextFormField(
                                  focusNode: _imgNode,
                                  textInputAction: TextInputAction.next,
                                  onFieldSubmitted: (value) =>
                                      _changeFocus(context, _imgNode, _eseNode),
                                  controller: _imgTextController,
                                  decoration:
                                      InputDecoration(hintText: 'Immagine'),
                                  onTap: () async {
                                    ImagePicker.pickImage(
                                            source: ImageSource.gallery)
                                        .then((img) {
                                      if (img != null) {
                                        _tempPath = img.path;
                                        _imgCtrl.add(_tempPath.split('/').last);
                                      } else {
                                        Toast.show(
                                            'Devi scegliere un\'immagine!',
                                            context,
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
                                padding: EdgeInsets.all(8.0),
                              );
                            },
                          ),
                          Padding(
                            child: TextFormField(
                              key: _eseKey,
                              focusNode: _eseNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) =>
                                  _changeFocus(context, _eseNode, _prodNode),
                              decoration: InputDecoration(
                                hintText: "Tipologia esercizio",
                              ),
                              validator: (value) {
                                if (value.length == 0) {
                                  return 'Inserisci tipologia';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          Padding(
                            child: TextFormField(
                              key: _prodKey,
                              focusNode: _prodNode,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (value) {
                                _prodNode.unfocus();
                                _upgrade(snap.data.model.id,context);
                              },
                              validator: (value) {
                                if (value.length == 0) {
                                  return 'Inserisci categoria';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Categoria merce",
                              ),
                              maxLines: 10,
                              minLines: 5,
                              keyboardType: TextInputType.text,
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                        ],
                      ),
                    ),
                    FlatButton(
                      child: Text('  Invia Richiesta  '),
                      onPressed: () {
                        _upgrade(snap.data.model.id,context);
                      },
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
