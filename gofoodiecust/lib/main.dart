// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gofoodiecust/auth/customer_login.dart';
import 'package:gofoodiecust/auth/customer_signup.dart';
import 'package:gofoodiecust/main_screens/customer_home.dart';
import 'package:gofoodiecust/main_screens/splash_screen.dart';
import 'package:gofoodiecust/main_screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gofoodiecust/providers/cart_provider.dart';
import 'package:gofoodiecust/providers/wish_provider.dart';
import 'package:gofoodiecust/services/notification_service.dart';
import 'package:provider/provider.dart';

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
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Cart()),
    ChangeNotifierProvider(create: (_) => Wish())
  ], child: const MyApp()));
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
        '/customer_home': (context) => const CustomerHomeScreen(),
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
      },
    );
  }
}
