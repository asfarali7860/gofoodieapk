// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gofoodiecust/table/book_table.dart';
import 'package:flutter/material.dart';
import 'package:gofoodiecust/main_screens/cart.dart';
import 'package:gofoodiecust/models/product_model.dart';
import 'package:gofoodiecust/providers/cart_provider.dart';
import 'package:gofoodiecust/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VisitStore extends StatefulWidget {
  final String? tablenum;
  final String suppId;
  final String? isQr;
  const VisitStore({Key? key, required this.suppId, this.isQr, this.tablenum})
      : super(key: key);

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;
  List<String> subscriptionsList = [];
  subscribetoTopic() {
    FirebaseMessaging.instance.subscribeToTopic('foodie');
    String id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .doc(id)
        .set({'customerid': id});
    setState(() {
      following = true;
    });
  }

  unsubscribetoTopic() {
    FirebaseMessaging.instance.unsubscribeFromTopic('foodie');
    String id = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .doc(id)
        .delete();
    setState(() {
      following = false;
    });
  }

  checkUserSubscription() {
    FirebaseFirestore.instance
        .collection('suppliers')
        .doc(widget.suppId)
        .collection('subscriptions')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        subscriptionsList.add(doc['customerid']);
      }
    }).whenComplete(() {
      following =
          subscriptionsList.contains(FirebaseAuth.instance.currentUser!.uid);
    });
  }

  @override
  void initState() {
    checkUserSubscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.grey,
                title: const Text('Store'),
                leading: const TealBackButton(),
              ),
              body: const Center(
                  child: Text(
                'This QR doesn\'t \n leads to any store',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Acme',
                  letterSpacing: 1.5,
                ),
              )));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Material(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.blueGrey.shade100,
                appBar: AppBar(
                  toolbarHeight: 150,
                  flexibleSpace: data['coverimage'] == ''
                      ? Image.asset(
                          'images/inapp/coverimage.jpg',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          data['coverimage'],
                          fit: BoxFit.cover,
                        ),
                  leading: const TealBackButton(),
                  title: Row(
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.teal),
                            borderRadius: BorderRadius.circular(15)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.network(
                            data['storelogo'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    data['storename'].toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.teal),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    border: Border.all(
                                        width: 3, color: Colors.white),
                                    borderRadius: BorderRadius.circular(25)),
                                child: MaterialButton(
                                  onPressed: following == false
                                      ? () {
                                          subscribetoTopic();
                                        }
                                      : () {
                                          unsubscribetoTopic();
                                        },
                                  child: following == true
                                      ? const Text(
                                          'UNFOLLOW',
                                          style: TextStyle(fontSize: 10),
                                        )
                                      : const Text(
                                          'FOLLOW',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                body: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _productStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Material(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(
                                height: 150,
                              ),
                              Text(
                                'This category \n\n has no items yet !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Acme',
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          );
                        }

                        return SingleChildScrollView(
                          child: StaggeredGridView.countBuilder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            crossAxisCount: 2,
                            itemBuilder: (context, index) {
                              return ProductModel(
                                products: snapshot.data!.docs[index],
                                isQr: widget.isQr,
                              );
                            },
                            staggeredTileBuilder: (context) =>
                                const StaggeredTile.fit(1),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                floatingActionButton:
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.teal,
                      onPressed: () {},
                      child: const Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ]),
                bottomSheet: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: Colors.blue,
                        minWidth: 200,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookTable(
                                        data: data,
                                      )));
                        },
                        child: const Text(
                          'Book Table',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartScreen(
                                        back: const AppBarBackButton(),
                                        suppId: widget.suppId,
                                        tablenum: widget.tablenum,
                                      )));
                        },
                        icon: badges.Badge(
                          showBadge: context.read<Cart>().getItems.isEmpty
                              ? false
                              : true,
                          badgeColor: Colors.teal,
                          badgeContent: Text(
                            context.watch<Cart>().getItems.length.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          child: const Icon(
                            Icons.shopping_cart,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Text("");
      },
    );
  }
}
