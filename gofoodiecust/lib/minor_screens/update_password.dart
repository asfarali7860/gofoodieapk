// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofoodiecust/main_screens/customer_home.dart';
import 'package:gofoodiecust/providers/auth_repo.dart';
import 'package:gofoodiecust/widgets/appbar_widget.dart';
import 'package:gofoodiecust/widgets/snackbar.dart';
import 'package:gofoodiecust/widgets/yellow_button.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool checkPassword = true;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const AppBarBackButton(),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Change Password'),
        ),
        body: SafeArea(
            child: Form(
          key: formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'to change your password\n\n please fill the form below\n and click on the button',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'acme'),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter your password';
                            }
                            return null;
                          },
                          controller: oldPasswordController,
                          decoration: emailFormDecoration.copyWith(
                            labelText: 'Old Password',
                            hintText: 'Enter your current Password',
                            errorText: checkPassword != true
                                ? 'not valid password'
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter your new password';
                            }
                            return null;
                          },
                          controller: newPasswordController,
                          decoration: emailFormDecoration.copyWith(
                            labelText: 'New Password',
                            hintText: 'Enter your new password',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'enter your new password';
                            } else if (value != newPasswordController.text) {
                              return 'password not matching';
                            }
                            return null;
                          },
                          decoration: emailFormDecoration.copyWith(
                            labelText: 'Repeat Password',
                            hintText: 'Re-Enter your new password',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FlutterPwValidator(
                      controller: newPasswordController,
                      minLength: 6,
                      uppercaseCharCount: 1,
                      numericCharCount: 2,
                      specialCharCount: 1,
                      width: 400,
                      height: 150,
                      onSuccess: () {},
                      onFail: () {}),
                  const SizedBox(
                    height: 75,
                  ),
                  YellowButton(
                      label: 'Update Password',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          checkPassword = await AuthRepo.checkOldPassword(
                              FirebaseAuth.instance.currentUser!.email!,
                              oldPasswordController.text);
                          setState(() {});
                          checkPassword == true
                              ? await AuthRepo.updateUserPassword(
                                      newPasswordController.text.trim())
                                  .whenComplete(() {
                                  formKey.currentState!.reset;
                                  newPasswordController.clear();
                                  oldPasswordController.clear();

                                  MyMessageHandler.showSnackBar(scaffoldKey,
                                      'your password has been updates');
                                  Future.delayed(const Duration(seconds: 3))
                                      .whenComplete(() => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CustomerHomeScreen())));
                                })
                              : print('not valid old password');
                          print('valid');
                        } else {
                          print('not valid');
                        }
                      },
                      width: 0.7)
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }

  var emailFormDecoration = InputDecoration(
      labelText: 'Full Name',
      hintText: 'Enter your full name',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          borderRadius: BorderRadius.circular(25)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(25)));
}
