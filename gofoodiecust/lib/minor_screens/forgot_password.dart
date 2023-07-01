// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofoodiecust/widgets/appbar_widget.dart';
import 'package:gofoodiecust/widgets/auth_widgets.dart';
import 'package:gofoodiecust/widgets/yellow_button.dart';

class FOrgotPassword extends StatefulWidget {
  const FOrgotPassword({super.key});

  @override
  State<FOrgotPassword> createState() => _FOrgotPasswordState();
}

class _FOrgotPasswordState extends State<FOrgotPassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const AppBarBackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Forgot Password?'),
      ),
      body: SafeArea(
          child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'to reset your password\n\n please Enter your email address\n and click on the button below',
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
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'please enter your email';
                  } else if (!value.isValidEmail()) {
                    return 'ivalid email';
                  } else if (value.isValidEmail()) {
                    return null;
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: emailFormDecoration.copyWith(
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              YellowButton(
                  label: 'Send Reset  Password Link',
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailController.text.trim());
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      print('form not valid');
                    }
                  },
                  width: 0.7)
            ],
          ),
        ),
      )),
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
