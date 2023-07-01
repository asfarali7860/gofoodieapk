// ignore_for_file: avoid_print

import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:suppgofood/main_screens/category.dart';
import 'package:suppgofood/main_screens/dashboard.dart';
import 'package:suppgofood/main_screens/home.dart';
import 'package:suppgofood/main_screens/store.dart';
import 'package:suppgofood/main_screens/upload_product.dart';
import 'package:suppgofood/services/notification_services.dart';


Future<void> saveTokenToDatabase(String token) async {
  // Assume user is logged in for this example
  String userId = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance.collection('suppliers').doc(userId).update({
    'tokens': FieldValue.arrayUnion([token]),
  });
}

class SupplierHomeScreen extends StatefulWidget {
  const SupplierHomeScreen({Key? key}) : super(key: key);

  @override
  State<SupplierHomeScreen> createState() => _SupplierHomeScreenState();
}

class _SupplierHomeScreenState extends State<SupplierHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabs = [
    const HomeScreen(),
    const CategoryScreen(),
    const StoresScreen(),
    DashboardScreen(),
    const UploadProductScreen()
  ];
  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();

    // Save the initial token to the database
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  @override
  void initState() {
    setupToken();
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        NotificationServices.displayNotification(message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('deliverystatus', isEqualTo: 'preparing')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
            body: _tabs[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w600),
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.red.shade300,
                currentIndex: _selectedIndex,
                items: [
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.search), label: 'Category'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.shop), label: 'Stores'),
                  BottomNavigationBarItem(
                      icon: badges.Badge(
                          showBadge: snapshot.data!.docs.isEmpty ? false : true,
                          badgeContent: Text(
                            snapshot.data!.docs.length.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          child: const Icon(Icons.dashboard)),
                      label: 'DashBoard'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.upload), label: 'Upload'),
                ],
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }));
      },
    );
  }
}
