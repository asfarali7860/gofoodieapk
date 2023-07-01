import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:multi_store_app/minor_screens/place_order.dart';
import 'package:gofoodiecust/providers/cart_provider.dart';
import 'package:gofoodiecust/widgets/appbar_widget.dart';
import 'package:gofoodiecust/widgets/yellow_button.dart';
import 'package:provider/provider.dart';

class HomeRestOrder extends StatefulWidget {
  const HomeRestOrder({Key? key}) : super(key: key);

  @override
  State<HomeRestOrder> createState() => _HomeRestOrderState();
}

class _HomeRestOrderState extends State<HomeRestOrder> {
  bool processing = true;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            int lengthItem = context.watch<Cart>().getItems.length;

            for (var i = 0; i < lengthItem; i++) {
              if (context.read<Cart>().getItems[i].suppId !=
                  context.read<Cart>().getItems.first.suppId) {
                processing = false;
              }
            }
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    leading: const AppBarBackButton(),
                    elevation: 0,
                    backgroundColor: Colors.grey.shade200,
                    title:
                        const Center(child: AppBarTitle(title: 'Order Place')),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(children: [
                      Container(
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Name: ${data['name']}'),
                              Text('Phone: ${data['phone']}'),
                              Text('Address: ${data['address']}')
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: processing == false
                              ? const SizedBox()
                              : Center(
                                  child: YellowButton(
                                    label: 'For Home',
                                    width: 0.6,
                                    onPressed: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const PlaceOrderScreen()));
                                    },
                                  ),
                                ))
                    ]),
                  ),
                  bottomSheet: Container(
                    height: 100,
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: YellowButton(
                        label: 'Confirm Payment',
                        width: 1,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
