import 'dart:math';

import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late int randomGeneratedFromLeft;
  late int randomGeneratedFromRight;

//Value assign to var before call build func
  @override
  void initState() {
    randomGeneratedFromLeft = 0;
    randomGeneratedFromRight = 0;
    super.initState();
  }

//Set random num
  void generateFunc() {
    setState(() {
      randomGeneratedFromLeft = randomNumber();
      randomGeneratedFromRight = randomNumber();
    });
  }

//Generate random num
  int randomNumber() {
    return Random().nextInt(6) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("data"),
        ListView(children: []),
      ],
    );
  }
}
