// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:suppgofood/auth/supplier_login.dart';
import 'package:suppgofood/auth/supplier_signup.dart';
import 'package:suppgofood/main_screens/splash_screen.dart';
import 'package:suppgofood/main_screens/supplier_home.dart';
import 'package:suppgofood/main_screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:suppgofood/services/notification_services.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  print("Handling a background message: ${message.notification!.title}");
  print("Handling a background message: ${message.notification!.body}");
  print("Handling a background message: ${message.data}");
  print("Handling a background message: ${message.data['key1']}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationServices.createNotificationChannelAndInitialize();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: WelcomeScreen(),
      initialRoute: '/onboard_screen',
      routes: {
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/onboard_screen': (context) => const SplashScreen(),
        '/supplier_home': (context) => const SupplierHomeScreen(),
        '/supplier_signup': (context) => const SupplierRegister(),
        '/supplier_login': (context) => const SupplierLogin(),
      },
    );
  }
}
