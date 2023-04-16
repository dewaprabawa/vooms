import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class ImageService {
  Future<String> uploadImage(File imageFile);
}

class ImageServiceImpl implements ImageService {
  final FirebaseStorage _firebaseStorage;

  ImageServiceImpl(this._firebaseStorage);

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      final imageName = '${DateTime.now().millisecondsSinceEpoch}';
      final ref = _firebaseStorage.ref().child('images/$imageName');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      debugPrint(e.code);
      throw e;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
