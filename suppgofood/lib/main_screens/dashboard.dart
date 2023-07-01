// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suppgofood/dashboard_components/qr_generator.dart';
import 'package:suppgofood/dashboard_components/manage_products.dart';
import 'package:suppgofood/dashboard_components/sup_balance.dart';
import 'package:suppgofood/dashboard_components/sup_orders.dart';
import 'package:suppgofood/dashboard_components/sup_statics.dart';
import 'package:suppgofood/main_screens/visit_store.dart';
import 'package:suppgofood/table/sup_tables.dart';
import 'package:suppgofood/widgets/alert_dialog.dart';
import 'package:suppgofood/widgets/appbar_widget.dart';

List<String> label = [
  'My Store',
  'Orders',
  'Tables',
  'Qr\nGenerator',
  'Manage\nProducts',
  'balance',
  'Statics',
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.table_chart_sharp,
  Icons.qr_code_2_outlined,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart
];

List<Widget> pages = [
  VisitStore(
    suppId: FirebaseAuth.instance.currentUser!.uid,
  ),
  const SuppliersOrders(),
  const SuppliersTables(),
  EditBusiness(
    documentId: FirebaseAuth.instance.currentUser!.uid,
  ),
  const ManageProducts(),
  const BalanceScreen(),
  const StaticScreen()
];

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(
            title: 'Dashboard',
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  MyAlertDialog.showMyDialog(
                      context: context,
                      title: 'Log Out',
                      content: 'Are you sure to log out?',
                      tabNo: () {
                        Navigator.pop(context);
                      },
                      tabYes: () async {
                        await FirebaseAuth.instance.signOut();
                        final SharedPreferences pref = await _prefs;
                        pref.setString('supplierid', '');
                        await Future.delayed(const Duration(microseconds: 100))
                            .whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                              context, '/welcome_screen');
                        });
                      });
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ))
          ]),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(7, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => pages[index]));
              },
              child: Card(
                color: Colors.teal.withOpacity(0.7),
                // ignore: prefer_const_literals_to_create_immutables
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        icons[index],
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        label[index].toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            fontFamily: 'Acme'),
                      )
                    ]),
              ),
            );
          }),
        ),
      ),
    );
  }
}
