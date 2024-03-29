// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../failure.dart';
import '../../type_defs.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  ((ref) => CommonFirebaseStorageRepository(
      firebaseStorage: FirebaseStorage.instance)),
);

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorageRepository({
    required this.firebaseStorage,
  });

  FutureEither<String> storageFileToFirebase(String path, File file) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(path).putFile(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return right(downloadUrl);
    } on FirebaseException catch (e) {
      throw e.toString();
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
