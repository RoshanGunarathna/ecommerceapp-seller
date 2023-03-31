import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/custom_button.dart';
import '../../../core/palette.dart';
import '../../../core/utils.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenConsumerState();
}

class _LoginScreenConsumerState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneController.dispose();
  }

  void sendPhoneNumber() {
    String phoneNumber = "+94${_phoneController.text.trim()}";
    if (phoneNumber.isNotEmpty && phoneNumber.length == 12) {
      ref
          .read(authControllerProvider.notifier)
          .signInWithPhone(context, phoneNumber);
    } else {
      showSnackBar(context: context, text: 'Phone number is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
                width: double.infinity,
                child: Text(
                  'E-commerce App will needs to verify your phone number',
                  textAlign: TextAlign.start,
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 30,
                  width: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    '+94',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 250,
                  child: TextField(
                      controller: _phoneController,
                      style: const TextStyle(fontSize: 25),
                      decoration: const InputDecoration(
                        hintText: "7XXXXXXXX",
                        hintStyle: TextStyle(color: blackColorShade2),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(9),
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            isLoading
                ? SizedBox(
                    height: 35,
                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        print('clicked');
                      },
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            minimumSize: const Size(double.infinity, 50)),
                        onPressed: () {},
                        child: const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: primaryColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                secondaryColor, //<-- SEE HERE
                              ),
                            )),
                      ),
                    ))
                : SizedBox(
                    height: 35,
                    width: 100,
                    child: CustomButton(
                        text: 'Next',
                        onPressed: () {
                          sendPhoneNumber();
                        })),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
