import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Timer? countDownTimer;
  int seconds = 3;
  String customerId = '';

  @override
  void initState() {
    startTimer();
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('customerid') ?? '';
    }).then((String value) {
      setState(() {
        customerId = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds == 0) {
        stopTimer();
        customerId != ''
            ? Navigator.pushReplacementNamed(context, '/customer_home')
            : Navigator.pushReplacementNamed(context, '/welcome_screen');
      }
    });
  }

  void stopTimer() {
    countDownTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image(
        height: 600,
        width: 600,
        image: AssetImage('images/inapp/splashc.gif'),
      )),
    );
  }
}
