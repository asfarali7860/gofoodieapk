import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suppgofood/widgets/appbar_widget.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          double totalPrice = 0.0;
          for (var item in snapshot.data!.docs) {
            totalPrice += item['orderqty'] * item['orderprice'];
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              title: const AppBarTitle(title: 'Balance'),
              leading: const AppBarBackButton(),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StaticsModel(
                    label: 'TOTAL BALANCE',
                    value: totalPrice,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                      height: 65,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(25)),
                      child: MaterialButton(
                        onPressed: () {},
                        child: const Text(
                          'Get Money',
                          style: TextStyle(color: Colors.white, fontSize: 26),
                        ),
                      ))
                ],
              ),
            ),
          );
        });
  }
}

class StaticsModel extends StatelessWidget {
  final String label;
  final dynamic value;
  const StaticsModel({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                  letterSpacing: 1.2),
            ),
          ),
        )
      ],
    );
  }
}
