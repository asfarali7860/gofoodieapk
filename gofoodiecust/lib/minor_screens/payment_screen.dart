// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_const_constructors, depend_on_referenced_packages, prefer_final_fields, duplicate_ignore

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:gofoodiecust/main_screens/customer_home.dart';
import 'package:gofoodiecust/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gofoodiecust/providers/cart_provider.dart';
import 'package:gofoodiecust/widgets/appbar_widget.dart';
import 'package:gofoodiecust/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String? message;
  final dynamic data;
  final String? suppid;
  final String? tablenum;
  const PaymentScreen(
      {Key? key, required this.data, this.suppid, this.tablenum, this.message})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String orderdatetime =
      "${DateFormat("yyyy-MM-dd").format(DateTime.now())} ${DateFormat("hh:mm:ss a").format(DateTime.now())}";
  var _razorpay = Razorpay();
  var amountController = TextEditingController();
  bool isSuccess = false;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // YellowButton(
    //                                             label: progressDone == false
    //                                                 ? 'Confirm Rs ${totalPaid.toStringAsFixed(2)}'
    //                                                 : 'Order Ongoing',
    isSuccess = true;

    for (var item in context.read<Cart>().getItems) {
      CollectionReference orderRef =
          FirebaseFirestore.instance.collection('orders');
      orderId = const Uuid().v4();
      await orderRef.doc(orderId).set({
        'cid': widget.data['cid'],
        'custname': widget.data['name'],
        'email': widget.data['email'],
        'adress': widget.data['address'],
        'phone': widget.data['phone'],
        'profileimage': widget.data['profileimage'],
        'sid': item.suppId,
        'proid': item.documentId,
        'orderid': orderId,
        'ordername': item.name,
        'orderimage': item.imagesUrl.first,
        'orderprice': item.qty * item.price,
        'orderdatetime': orderdatetime,
        'orderqty': item.qty,
        'message': widget.message,
        'deliverystatus': 'preparing',
        'deliverytime': '',
        'orderdate': DateTime.now(),
        'paymentstatus': 'Paid by RazorPay',
        'orderreview': false,
        'tablenumber': widget.tablenum
      }).whenComplete(() async {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection('products')
              .doc(item.documentId);
          DocumentSnapshot snapshot2 = await transaction.get(documentReference);
          transaction.update(
              documentReference, {'instock': snapshot2['instock'] - item.qty});
        });
      });
    }
    context.read<Cart>().clearCart();
    Navigator.popUntil(context, ModalRoute.withName('/customer_home'));
    

    print('Payment Done Successfully');
  }

  
  

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    // ignore: avoid_print

    print('Payment fail');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  int selectedValue = 1;
  bool progressDone = false;
  late String orderId;
  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
        max: 100, msg: 'please wait ..', progressBgColor: Colors.teal);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalGST = context.watch<Cart>().totalPrice / 20;

    double totalPaid = context.watch<Cart>().totalPrice + totalGST;

    return FutureBuilder<DocumentSnapshot>(
        future: suppliers.doc(widget.suppid).get(),
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
            Map<String, dynamic> supp =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: ScaffoldMessenger(
                  key: _scaffoldKey,
                  child: Scaffold(
                    backgroundColor: Colors.grey.shade200,
                    appBar: AppBar(
                      leading: const AppBarBackButton(),
                      elevation: 0,
                      backgroundColor: Colors.grey.shade200,
                      title: const Center(child: AppBarTitle(title: 'Payment')),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                      child: Column(children: [
                        Container(
                          height: 150,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      'Rs ${totalPaid.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Order',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      'Rs ${totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'GST',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      'Rs ${totalGST.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.redAccent,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Table: ',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      widget.message.toString(),
                                      // widget.tablenum.toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Cash on Counter'),
                                subtitle: const Text(' Pay at your table'),
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedValue,
                                onChanged: (int? value) {
                                  setState(() {
                                    selectedValue = value!;
                                  });
                                },
                                title: const Text('Pay via Online Mode'),
                                subtitle: Row(
                                  children: const [
                                    Icon(Icons.payment),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Icon(FontAwesomeIcons.ccVisa),
                                    ),
                                    Icon(FontAwesomeIcons.ccAmazonPay),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))
                      ]),
                    ),
                    bottomSheet: Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: YellowButton(
                          label: 'Confirm Rs ${totalPaid.toStringAsFixed(2)}',
                          width: 1,
                          onPressed: () {
                            if (selectedValue == 1) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Column(children: [
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            'Pay At Counter Rs ${totalPaid.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 22,
                                                color: Color.fromARGB(
                                                    255, 52, 52, 52)),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          supp['address'] ==
                                                  widget.data['curraddress']
                                              ? YellowButton(
                                                  label: progressDone == false
                                                      ? 'Confirm Rs ${totalPaid.toStringAsFixed(2)}'
                                                      : 'Order Ongoing',
                                                  onPressed: progressDone ==
                                                          false
                                                      ? () async {
                                                          showProgress();
                                                          progressDone = true;
                                                          for (var item
                                                              in context
                                                                  .read<Cart>()
                                                                  .getItems) {
                                                            CollectionReference
                                                                orderRef =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'orders');
                                                            orderId =
                                                                const Uuid()
                                                                    .v4();
                                                            await orderRef
                                                                .doc(orderId)
                                                                .set({
                                                              'cid': widget
                                                                  .data['cid'],
                                                              'custname': widget
                                                                  .data['name'],
                                                              'email':
                                                                  widget.data[
                                                                      'email'],
                                                              'adress': widget
                                                                      .data[
                                                                  'address'],
                                                              'phone':
                                                                  widget.data[
                                                                      'phone'],
                                                              'profileimage':
                                                                  widget.data[
                                                                      'profileimage'],
                                                              'sid':
                                                                  item.suppId,
                                                              'proid': item
                                                                  .documentId,
                                                              'orderid':
                                                                  orderId,
                                                              'ordername':
                                                                  item.name,
                                                              'orderimage': item
                                                                  .imagesUrl
                                                                  .first,
                                                              'orderprice': item
                                                                      .qty *
                                                                  item.price,
                                                              'message': widget
                                                                  .message,
                                                              'orderdatetime':
                                                                  orderdatetime,
                                                              'orderqty':
                                                                  item.qty,
                                                              'deliverystatus':
                                                                  'preparing',
                                                              'deliverytime':
                                                                  '',
                                                              'orderdate':
                                                                  DateTime
                                                                      .now(),
                                                              'paymentstatus':
                                                                  'cash on delivery',
                                                              'orderreview':
                                                                  false,
                                                              'tablenumber':
                                                                  widget
                                                                      .tablenum
                                                            }).whenComplete(
                                                                    () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .runTransaction(
                                                                      (transaction) async {
                                                                DocumentReference
                                                                    documentReference =
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'products')
                                                                        .doc(item
                                                                            .documentId);
                                                                DocumentSnapshot
                                                                    snapshot2 =
                                                                    await transaction
                                                                        .get(
                                                                            documentReference);
                                                                transaction.update(
                                                                    documentReference,
                                                                    {
                                                                      'instock':
                                                                          snapshot2['instock'] -
                                                                              item.qty
                                                                    });
                                                              });
                                                            });
                                                          }
                                                          context
                                                              .read<Cart>()
                                                              .clearCart();
                                                          Navigator.popUntil(
                                                              context,
                                                              ModalRoute.withName(
                                                                  '/customer_home'));
                                                                  
                                                        }
                                                      : () {},
                                                  width: 0.8)
                                              : YellowButton(
                                                  label:
                                                      'Confirm Rs ${totalPaid.toStringAsFixed(2)}',
                                                  onPressed: () {
                                                    MyMessageHandler.showSnackBar(
                                                        _scaffoldKey,
                                                        'You are not at the restaurant, for changing current location go back and click on Location Pin!!');
                                                  },
                                                  width: 0.8)
                                        ]),
                                      ));
                            } else if (selectedValue == 2) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: Column(children: [
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            'Pay Online Rs ${totalPaid.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 22,
                                                color: Color.fromARGB(
                                                    255, 52, 52, 52)),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          // supp['address'] == widget.currAddress
                                          // ?
                                          isSuccess == false
                                              ? YellowButton(
                                                  label:
                                                      'Rs ${totalPaid.toStringAsFixed(2)}',
                                                  onPressed: () {
                                                    var options = {
                                                      'key':
                                                          "rzp_test_D7OBUgzpNhaCo3",
                                                      // 'amount':
                                                      //     (int.parse(amountController.text) * 100).toString(),
                                                      'amount': totalPaid * 100,
                                                      'name':
                                                          widget.data['name'],
                                                      'description':
                                                          'Delicious Food',
                                                      'timeout': 300,
                                                      'prefill': {
                                                        'contact':
                                                            '${widget.data['phone']}',
                                                        'email':
                                                            '${widget.data['email']}'
                                                      }
                                                    };
                                                    _razorpay.open(options);
                                                  },
                                                  width: 0.8)
                                              : YellowButton(
                                                  label: 'Wait...',
                                                  onPressed: () {
                                                    // MyMessageHandler.showSnackBar(
                                                    //     _scaffoldKey,
                                                    //     'You are not at the restaurant, for changing current ocation go back and click on Location Pin!!');
                                                  },
                                                  width: 0.8)
                                        ]),
                                      ));

                              // makePayment();
                            }
                          },
                        ),
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

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }
}
