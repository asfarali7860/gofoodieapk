// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gofoodiecust/widgets/yellow_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const textColors = [Colors.redAccent, Colors.orange, Colors.teal, Colors.red];
const textStyle =
    TextStyle(fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'Acme');

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool processing = false;
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText('Go Foodie',
                    textStyle: textStyle, colors: textColors),
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
            // const Text(
            //   'WELCOME',
            //   style: TextStyle(color: Colors.white, fontSize: 30),
            // ),
            const SizedBox(
              height: 300,
              width: 300,
              child: Image(image: AssetImage('images/inapp/splashc.gif')),
            ),
            SizedBox(
              height: 80,
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Acme'),
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText(' '),
                    RotateAnimatedText('ORDER FROM RESTRAUNT TABLE'),
                  ],
                  repeatForever: true,
                ),
              ),
            ),
            // const Text(
            //   'BUY FOR HOME',
            //   style: TextStyle(color: Colors.white, fontSize: 30),
            // ),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: YellowButton(
                      label: 'Log In',
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/customer_login');
                      },
                      width: 0.8),
                ),
                const SizedBox(
                  height: 20,
                ),
                YellowButton(
                    label: 'Sign Up',
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/customer_signup');
                    },
                    width: 0.8),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    Key? key,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: ((context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      }),
      child: const Image(image: AssetImage('images/inapp/logo.jpg')),
    );
  }
}

class GoogleFacebookLogin extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget child;
  const GoogleFacebookLogin(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(height: 50, width: 50, child: child),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
