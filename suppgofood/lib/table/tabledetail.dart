import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suppgofood/widgets/snackbar.dart';

class SupplierTableModel extends StatefulWidget {
  final dynamic table;
  const SupplierTableModel({Key? key, required this.table}) : super(key: key);

  @override
  State<SupplierTableModel> createState() => _SupplierTableModelState();
}

class _SupplierTableModelState extends State<SupplierTableModel> {
  late String numbe;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.teal),
            borderRadius: BorderRadius.circular(15)),
        child: ExpansionTile(
          title: Container(
            constraints: const BoxConstraints(maxHeight: 120),
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Container(
                    constraints:
                        const BoxConstraints(maxHeight: 80, maxWidth: 80),
                    child: Image.network(widget.table['suppimage']),
                  ),
                ),
                Flexible(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.table['suppname'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Table Booked Date',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.table['bookingdate'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.teal,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    widget.table['tablenumber'] != ''
                        ? Row(
                            children: [
                              Text(
                                'Table Number: ',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                widget.table['tablenumber'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ))
              ],
            ),
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('see more..'), Text(widget.table['status'])],
          ),
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widget.table['status'] == 'confirmed'
                      ? Colors.brown.withOpacity(0.2)
                      : Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ('Name: ') + (widget.table['custname']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Phone No.: ') + (widget.table['phone']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Email Address: ') + (widget.table['email']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Table No.: ') + (widget.table['tablenumber']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          const Text(
                            ('Status: '),
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            (widget.table['status']),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.teal),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            ('Table Booked Date: '),
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            (widget.table['bookingdate']),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.red),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            ('Table Booked Time: '),
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            (widget.table['bookedtime']),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.red),
                          )
                        ],
                      ),
                      widget.table['status'] == 'confirmed'
                          ? const Text('')
                          : Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: const [
                                      Text(
                                        ('Change Booking Status To: '),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    // controller: personController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'enter the table number';
                                      } else if (value.isValidTableNumber() !=
                                          true) {
                                        return 'not valid Table Number';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      numbe = value;
                                    },
                                    decoration: emailFormDecoration.copyWith(
                                      labelText: 'Table Number',
                                      hintText: 'Enter table number? ',
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await FirebaseFirestore.instance
                                              .collection('tables')
                                              .doc(widget.table['tableid'])
                                              .update({
                                            'status': 'confirmed',
                                            'tablenumber': numbe
                                          });
                                        } else {
                                          MyMessageHandler.showSnackBar(
                                              _scaffoldKey,
                                              'Please fill table number');
                                        }
                                      },
                                      child: const Text('Confirm Booking'))
                                ],
                              ),
                            ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
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
