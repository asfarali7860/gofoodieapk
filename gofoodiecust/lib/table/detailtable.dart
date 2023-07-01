// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gofoodiecust/widgets/appbar_widget.dart';
import 'package:gofoodiecust/widgets/snackbar.dart';
import 'package:gofoodiecust/widgets/yellow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DetailedTable extends StatefulWidget {
  final dynamic data;
  final String time;
  final String date;

  const DetailedTable(
      {super.key, required this.data, required this.time, required this.date});

  @override
  State<DetailedTable> createState() => _DetailedTableState();
}

class _DetailedTableState extends State<DetailedTable> {
  late String numbe;
  late String message = 'no message';
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  late String tableId;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

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
            Map<String, dynamic> cust =
                snapshot.data!.data() as Map<String, dynamic>;

            return ScaffoldMessenger(
              key: scaffoldKey,
              child: Scaffold(
                appBar: AppBar(
                  leading: const AppBarBackButton(),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: formState,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 125,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Time Slot: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(widget.time,
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Date: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text(widget.date,
                                  style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            // controller: personController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter number of Persons';
                              } else if (value.isValidTableNumber() != true) {
                                return 'not valid Persons Number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              numbe = value;
                            },
                            decoration: emailFormDecoration.copyWith(
                              labelText: 'Number of Persons',
                              hintText: 'Enter Number of Persons',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            onChanged: (value) {
                              message = value;
                            },
                            maxLines: 3,
                            // controller: messageController,
                            decoration: emailFormDecoration.copyWith(
                              labelText: 'Message for us',
                              hintText: 'Enter Message for us',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomSheet: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: YellowButton(
                          label: 'Book Table',
                          onPressed: () async {
                            if (formState.currentState!.validate()) {
                              CollectionReference tableRef = FirebaseFirestore
                                  .instance
                                  .collection('tables');
                              tableId = const Uuid().v4();
                              await tableRef.doc(tableId).set({
                                'cid': cust['cid'],
                                'custname': cust['name'],
                                'email': cust['email'],
                                'adress': cust['address'],
                                'phone': cust['phone'],
                                'profileimage': cust['profileimage'],
                                'sid': widget.data['sid'],
                                'suppname': widget.data['storename'],
                                'suppimage': widget.data['storelogo'],
                                'tableid': tableId,
                                'status': 'not confirmed',
                                'bookedtime': widget.time,
                                'bookingdate': widget.date,
                                'tablenumber': '',
                                'numperson': numbe,
                                'message': message != 'no message'
                                    ? message
                                    : 'no message'
                              });
                              Navigator.popUntil(context,
                                  ModalRoute.withName('/customer_home'));
                            } else {
                              MyMessageHandler.showSnackBar(
                                  scaffoldKey, 'Please fill number of persons');
                            }
                          },
                          width: 0.45),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
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

extension TableValidator on String {
  bool isValidTableNumber() {
    return RegExp(r'^([0-9]{1,2})$').hasMatch(this);
  }
}
