import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_seller_app/core/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/palette.dart';
import '../../../core/utils.dart';
import '../controller/auth_controller.dart';

class LoginInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const LoginInformationScreen({super.key});

  @override
  ConsumerState<LoginInformationScreen> createState() =>
      _LoginInformationScreenConsumerState();
}

class _LoginInformationScreenConsumerState
    extends ConsumerState<LoginInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    final images = await pickImages(context);
    image = images[0];

    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text;

    if (name.isEmpty) {
      showSnackBar(context: context, text: 'Please enter your name');
      return null;
    }
    if (image == null) {
      showSnackBar(context: context, text: 'Please add a display picture');
      return null;
    }

    ref.read(authControllerProvider.notifier).saveSellerUserDataToFirebase(
        name: name, profilePic: image, context: context);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                image == null
                    ? CircleAvatar(
                        backgroundColor: whiteColor,
                        radius: size.height * 0.094,
                        backgroundImage: const NetworkImage(
                          Constants.avatarDefault,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: secondaryColor,
                        radius: size.height * 0.094,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                  top: 78,
                  left: 78,
                  child: IconButton(
                    onPressed: () {
                      selectImage();
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.80,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    style: const TextStyle(fontSize: 20),
                    inputFormatters: [LengthLimitingTextInputFormatter(30)],
                    controller: nameController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your name'),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  height: 50,
                  width: size.width * 0.15,
                  child: IconButton(
                    color: secondaryColor,
                    onPressed: storeUserData,
                    icon: const Icon(Icons.done),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}