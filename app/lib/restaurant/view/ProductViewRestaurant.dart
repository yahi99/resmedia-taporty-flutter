import 'dart:async';
import 'dart:io';

import 'package:easy_route/easy_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:toast/toast.dart';

class ProductViewRestaurant extends StatelessWidget {
  final ProductModel model;
  //final StreamController<String> imgStream=new StreamController.broadcast();

  ProductViewRestaurant({Key key, @required this.model})
      : super(key: key);

  Future<Null> downloadFile(String httpPath)async{
    final RegExp regExp=RegExp('([^?/]*\.(jpg))');
    final String fileName=regExp.stringMatch(httpPath);
    final Directory tempDir= Directory.systemTemp;
    final File file=File('${tempDir.path}/$fileName');
    final StorageReference ref=FirebaseStorage.instance.ref().child(fileName);
    final StorageFileDownloadTask downloadTask=ref.writeToFile(file);
    final int byteNumber=(await downloadTask.future).totalByteCount;
    print(byteNumber);
    //put the file into the stream
    //imgStream.add(file.path);
  }

  _showPositionDialog(BuildContext context) {
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
              Column(
                children: <Widget>[
                  Text(
                    "Sicuro di volere cancellare questo prodotto?",
                    style: theme.textTheme.body2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          EasyRouter.pop(context);
                        },
                        textColor: Colors.white,
                        color: Colors.red,
                        child: Text(
                          "Nega",
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Database().deleteProduct(model.id, model.restaurantId, model.path.contains('foods')?'foods':'drinks').then((value) {
                            Toast.show('Prodotto cancellato', context);
                            EasyRouter.pop(context);
                          });
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Consenti",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //if(model.number!=null) downloadFile(model.img);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.blue,
          icon: Icons.close,
          onTap: () async {
            _showPositionDialog(context);
          },
        ),
      ],
      child: InkWell(
    child:DefaultTextStyle(
        style: theme.textTheme.body1,
        child: SizedBox(
          height: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset('assets/img/home/fotoprofilo.jpg'),
                      /*(model.img.startsWith('assets'))?Image.asset(
                          model.img,
                          fit: BoxFit.fitHeight,
                        ):Image.network(
                          model.img,
                          fit: BoxFit.fitHeight,
                        ),*/
                      ),
                    ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(child:Container(child: Text(model.id),width: MediaQuery.of(context).size.width*2/5),),
                      Text('€ ${model.price}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
        onTap: (){
          //EasyRouter.push(context, ManageProduct());
        },
      ),
    );
  }
}
