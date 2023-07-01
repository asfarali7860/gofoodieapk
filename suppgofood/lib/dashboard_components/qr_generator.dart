// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suppgofood/minor_screens/qr_genzy.dart';
import 'package:suppgofood/widgets/appbar_widget.dart';
import 'package:suppgofood/widgets/snackbar.dart';
import 'package:suppgofood/widgets/yellow_button.dart';

class EditBusiness extends StatefulWidget {
  final String documentId;
  const EditBusiness({Key? key, required this.documentId}) : super(key: key);

  @override
  State<EditBusiness> createState() => _EditBusinessState();
}

class _EditBusinessState extends State<EditBusiness> {
  final TextEditingController tableController = TextEditingController();
  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: suppliers.doc(widget.documentId).get(),
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
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return ScaffoldMessenger(
              key: _scaffoldKey,
              child: Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    title: const AppBarTitle(title: 'QR Generator'),
                    leading: const AppBarBackButton(),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: tableController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'enter number of tables';
                                } else if (value.isValidTableNumber() != true) {
                                  return 'not valid Table Number';
                                }
                                return null;
                              },
                              decoration: emailFormDecoration.copyWith(
                                labelText: 'Number of Tables',
                                hintText: 'Enter Number of Tables',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          YellowButton(
                              label: 'Generate',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => QrListSCreen(
                                                data: data,
                                                suppId: FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                tableNum: tableController.text,
                                              )));
                                } else {
                                  MyMessageHandler.showSnackBar(_scaffoldKey,
                                      'Enter correct Table Number');
                                }
                              },
                              width: 0.9)
                        ],
                      ),
                    ),
                  )),
            );
          }
          return const Text('');
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
