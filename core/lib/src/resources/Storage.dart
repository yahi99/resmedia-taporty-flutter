import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class Storage {
  FirebaseStorage fbStorage = FirebaseStorage.instance;

  Future<String> uploadFile(String storagePath, File file) async {
    StorageReference storageReference = fbStorage.ref().child(storagePath + "/" + basename(file.path));
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File Uploaded');
    return await storageReference.getDownloadURL();
  }

  Future deleteFile(String storagePath) async {
    StorageReference storageReference = fbStorage.ref().child(storagePath);
    await storageReference.delete();
  }
}
