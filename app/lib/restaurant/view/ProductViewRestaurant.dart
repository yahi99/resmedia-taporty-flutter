import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';

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
          onTap: () async {},
        ),
      ],
      child: DefaultTextStyle(
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
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: (model.img.startsWith('assets'))?Image.asset(
                          model.img,
                          fit: BoxFit.fitHeight,
                        ):Image.network(
                          model.img,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          '${model.id.substring(0, (15 < model.id.length) ? 15 : model.id.length)}'),
                      Text('€ ${model.price}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
