import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages, unused_import
import 'package:intl/intl.dart';

class CustomerTableModel extends StatefulWidget {
  final dynamic order;
  const CustomerTableModel({Key? key, required this.order}) : super(key: key);

  @override
  State<CustomerTableModel> createState() => _CustomerTableModelState();
}

class _CustomerTableModelState extends State<CustomerTableModel> {
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
                    child: Image.network(widget.order['suppimage']),
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
                        widget.order['suppname'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 24,
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
                          widget.order['bookingdate'],
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
                    widget.order['tablenumber'] != ''
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
                                widget.order['tablenumber'],
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
            children: [const Text('see more..'), Text(widget.order['status'])],
          ),
          children: [
            Container(
              // height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: widget.order['status'] == 'confirmed'
                      ? Colors.brown.withOpacity(0.2)
                      : Colors.teal.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ('Name: ') + (widget.order['custname']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Phone No.: ') + (widget.order['phone']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Email Address: ') + (widget.order['email']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        ('Table No.: ') + (widget.order['tablenumber']),
                        style: const TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          const Text(
                            ('Status: '),
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            (widget.order['status']),
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
                            (widget.order['bookingdate']),
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
                            (widget.order['bookedtime']),
                            style: const TextStyle(
                                fontSize: 15, color: Colors.red),
                          )
                        ],
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
