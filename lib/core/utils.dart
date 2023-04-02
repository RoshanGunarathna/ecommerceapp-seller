// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context, required String text}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
}

Future<List<File>> pickImages(BuildContext ctx) async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (files != null && files.files.isNotEmpty) {
      for (var i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    showSnackBar(context: ctx, text: e.toString());
  }
  return images;
}

//pick an one image
Future<File?> pickOneImage(BuildContext ctx) async {
  File? image;
  try {
    var result = await FilePicker.platform.pickFiles();
    if (result != null) {
      image = File(result.files.single.path!);
    }
    return image;
  } catch (e) {
    showSnackBar(context: ctx, text: e.toString());
    throw Future.error(e.toString());
  }
}
