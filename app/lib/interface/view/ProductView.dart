import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:toast/toast.dart';
import 'package:vibration/vibration.dart';

import '../../logic/bloc/CartBloc.dart';

class ProductView extends StatelessWidget {
  final ProductModel model;
  final CartControllerRule cartController;
  final String update;
  final String category;
  //final StreamController<String> imgStream=new StreamController.broadcast();

  ProductView(
      {Key key,
      @required this.model,@required this.category,
      @required this.cartController,
      @required this.update})
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

  Future<String> uploadFile(String filePath) async {
    try{
      final data=await rootBundle.load(filePath);
      final bytes=data.buffer.asUint8List();
      //final Uint8List bytes = File(filePath).readAsBytesSync();
      final Directory tempDir = Directory.systemTemp;
      final String fileName = filePath.split('/').last;
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes, mode: FileMode.write);
      print(filePath);
      final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
      final StorageUploadTask task = ref.putFile(file);
      final Uri downloadUrl = (await task.onComplete).uploadSessionUri;

      //Database().updateImgProduct(await ref.getDownloadURL(), model);
      //_path = downloadUrl.toString();
      return 'ok';
    }
    catch(e){
      print(e.toString());
    }
    return 'not ok';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if(model.isDisabled==null) Database().updateProdDis(model, category);
    if(model.img.startsWith('assets')) uploadFile(model.img);
    //if(model.number!=null) downloadFile(model.img);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.white10,
          icon: Icons.close,
          onTap: () async {
            final userId = (await UserBloc.of().outUser.first).model.id;
            cartController.inRemove(model.id, model.restaurantId, userId);
          },
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
                      Flexible(child:Container(child: Text(model.id),width: MediaQuery.of(context).size.width*2/5),),
                      Text('€ ${model.price}'),
                    ],
                  ),
                ],
              ),
              CartStepperButton(
                update: update,
                model: model,
                cartController: cartController,
                category: category,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartStepperButton extends StatelessWidget {
  final CartController cartController;
  final ProductModel model;
  final String update;
  final String category;

  const CartStepperButton(
      {Key key,
      @required this.cartController,
      @required this.model,
      @required this.update,
      @required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserBloc user = UserBloc.of();
    return StreamBuilder<Cart>(
      stream: cartController.outCart,
      builder: (_, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final cart = snapshot.data;
        return CacheStreamBuilder<FirebaseUser>(
          stream: user.outFirebaseUser,
          builder: (context, snap) {
            if (!snap.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            print(snap.data.uid);
            final product=cart.getProduct(model.id, model.restaurantId, snap.data.uid);
            if (product!=null && product.delete) {
              print(product.id+'  '+product.delete.toString()+'  menu');
              cartController.inRemove(
                  model.id, model.restaurantId, snap.data.uid);
            }
            return StepperButton(
              direction: Axis.vertical,
              child: Text(
                  '${cart.getProduct(model.id, model.restaurantId, snap.data.uid)?.countProducts ?? 0}'),
              onDecrease: () {
                Vibration.vibrate(duration: 65);
                cartController.inDecrease(
                    model.id, model.restaurantId, snap.data.uid);
              },
              onIncrement: () {
                print(model.number);
                final prod=cart.getProduct(model.id, model.restaurantId, snap.data.uid);
                final count=(prod!=null)?prod.countProducts:0;
                if(model.number!=null && int.parse(model.number)<=count)
                  Toast.show('Limite massimo prodotti',context,duration: 3);
                else {
                  Vibration.vibrate(duration: 65);
                  cartController.inIncrement(
                      model.id,
                      model.restaurantId,
                      snap.data.uid,
                      double.parse(model.price.replaceAll(',', '.')),
                      category);
                }
              },
            );
          },
        );
      },
    );
  }
}

/*class CartButton extends StatelessWidget {
  final int val;
  final ProductModel model;

  const CartButton({Key key, this.val, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final cart = CartBloc();
    final user = UserBloc.of();
    var cartStorage = CartStorage(
        storage:
            InternalStorage.manager(versionManager: VersionManager("Drink")));
    final cls = Theme.of(context).colorScheme;
    return Container(
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: cls.secondaryVariant),
      child: Column(
        children: <Widget>[
          CacheStreamBuilder<FirebaseUser>(
            stream: user.outFirebaseUser,
            builder: (context, snap) {
              if (!snap.hasData)
                return Center(
                  child: CircularProgressIndicator(),
                );
              print(snap.hasData);
              return Expanded(
                child: IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () {
                    //cart.inIncrementDrink(model);
                    List<ProductCart> temp = List<ProductCart>();
                    temp.add(ProductCart(
                        id: model.id,
                        restaurantId: model.restaurantId,
                        userId: snap.data.uid));
                    cartStorage = CartStorage(
                        storage: InternalStorage.manager(
                            versionManager: VersionManager("Drink")),
                        products: temp);
                    cartStorage.increment(
                        model.id,
                        model.restaurantId,
                        snap.data.uid,
                        double.parse(model.price.replaceAll(',', '.')),
                        ca);
                  },
                ),
              );
            },
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('$val'),
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.remove),
              color: Colors.white,
              onPressed: () {
                //cart.inIncrementDrink(model);
              },
            ),
          ),
        ],
      ),
    );
  }
}*/
