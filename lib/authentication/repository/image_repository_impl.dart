import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

abstract class ImageRepository {
  Future<String> uploadImage(File imageFile);
}

class ImageRepositoryImpl implements ImageRepository {
  final FirebaseStorage _firebaseStorage;

  ImageRepositoryImpl(this._firebaseStorage);

  @override
  Future<String> uploadImage(File imageFile) async {
    try {
      final imageName = '${DateTime.now().millisecondsSinceEpoch}';
      final ref = _firebaseStorage.ref().child('images/$imageName');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      // Check if an image with the same name already exists
      final existingRef = _firebaseStorage.ref().child('images/$imageName');
      final existingSnapshot =
          await existingRef.getDownloadURL().catchError((error) => null);
      if (existingSnapshot != null) {
        // If an image with the same name exists, delete it and replace it with the new one
        await existingRef.delete();
      }

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
