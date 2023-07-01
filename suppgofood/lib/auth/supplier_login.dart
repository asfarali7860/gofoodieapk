// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suppgofood/minor_screens/forgot_password.dart';
import 'package:suppgofood/providers/auth_repo.dart';
import 'package:suppgofood/widgets/auth_widgets.dart';
import 'package:suppgofood/widgets/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);

  @override
  State<SupplierLogin> createState() => _SupplierLoginState();
}

class _SupplierLoginState extends State<SupplierLogin> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String email;
  late String password;
  late String profileImage;
  bool processing = false;
  bool sendEmailVerification = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;

  void logIn() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);
        await AuthRepo.reloadUserData();
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          _formKey.currentState!.reset();
          User user = FirebaseAuth.instance.currentUser!;

          final SharedPreferences pref = await _prefs;
          pref.setString('supplierid', user.uid);

          Navigator.pushReplacementNamed(context, '/supplier_home');
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please check your inbox');
          setState(() {
            processing = false;
            sendEmailVerification = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
        // if (e.code == 'user-not-found') {
        //   setState(() {
        //     processing = false;
        //   });
        //   MyMessageHandler.showSnackBar(
        //       _scaffoldKey, 'No user found for that email');
        // } else if (e.code == 'wrong-password') {
        //   setState(() {
        //     processing = false;
        //   });
        //   MyMessageHandler.showSnackBar(_scaffoldKey, 'Wrong Password');
        // }
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: 'Log In',
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your email';
                              } else if (value.isValidEmail() == false) {
                                return 'invalid email';
                              } else if (value.isValidEmail() == true) {
                                return null;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              email = value;
                            },
                            // controller: _emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: textFormDecoration.copyWith(
                                labelText: 'Email Address',
                                hintText: 'Enter your email')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            // controller: _passwordcontroller,
                            obscureText: passwordVisible,
                            decoration: textFormDecoration.copyWith(
                                suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.redAccent,
                                    )),
                                labelText: 'Password',
                                hintText: 'Enter your password')),
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FOrgotPassword()));
                              },
                              child: const Text(
                                'Forget Password? ',
                                style: TextStyle(
                                    fontSize: 18, fontStyle: FontStyle.italic),
                              )),
                          sendEmailVerification == true
                              ? TextButton(
                                  onPressed: () async {
                                    try {
                                      await FirebaseAuth.instance.currentUser!
                                          .sendEmailVerification();
                                    } catch (e) {
                                      print(e);
                                    }
                                    Future.delayed(const Duration(seconds: 3))
                                        .whenComplete(() {
                                      setState(() {
                                        sendEmailVerification = false;
                                      });
                                    });
                                  },
                                  child: const Text(
                                    'Resend Email',
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic),
                                  ))
                              : const SizedBox(),
                        ],
                      ),
                      HaveAccount(
                        haveAccount: 'Don\'t Have Account? ',
                        actionLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_signup');
                        },
                      ),
                      processing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: Colors.redAccent,
                            ))
                          : AuthMainButton(
                              mainButtonLabel: 'Log In',
                              onPressed: () {
                                logIn();
                              },
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
