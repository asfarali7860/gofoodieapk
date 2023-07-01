import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suppgofood/main_screens/visit_store.dart';
import 'package:suppgofood/minor_screens/edit_product.dart';
import 'package:suppgofood/minor_screens/product_details.dart';

class ProductModel extends StatefulWidget {
  final dynamic products;
  final String? isQr;
  const ProductModel({Key? key, required this.products, this.isQr})
      : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');
    return FutureBuilder<DocumentSnapshot>(
        future: suppliers.doc(widget.products['sid']).get(),
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
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                              proList: widget.products,
                            )));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minHeight: 100, maxHeight: 250),
                            child: Image(
                              image:
                                  NetworkImage(widget.products['proimages'][0]),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                widget.products['proname'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Rs',
                                        style: TextStyle(
                                          color: Colors.red.shade600,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        widget.products['price']
                                            .toStringAsFixed(2),
                                        style: widget.products['discount'] != 0
                                            ? const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 8,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.w600,
                                              )
                                            : TextStyle(
                                                color: Colors.red.shade600,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                      ),
                                      widget.products['discount'] != 0
                                          ? Text(
                                              ((1 -
                                                          (widget.products[
                                                                  'discount'] /
                                                              100)) *
                                                      widget.products['price'])
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                color: Colors.red.shade600,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : const Text(''),
                                    ],
                                  ),
                                  widget.products['sid'] ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProduct(
                                                          item: widget.products,
                                                        )));
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.red,
                                            size: 20,
                                          ))
                                      : IconButton(
                                          onPressed: () {
                                           
                                          },
                                          icon: const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 30,
                                                )
                                              
                                        ),
                                ],
                              ),
                              // widget.products['sid'] ==
                              //         FirebaseAuth.instance.currentUser!.uid
                              InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VisitStore(
                                                        suppId: widget
                                                            .products['sid'])));
                                      },
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.store,
                                              size: 25,
                                            ),
                                          ),
                                          Text(
                                            data['storename'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.products['discount'] != 0
                      ? Positioned(
                          top: 20,
                          left: 0,
                          child: Container(
                            height: 25,
                            width: 80,
                            decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15))),
                            child: Center(
                              child: Text(
                                'Save ${widget.products['discount'].toString()} %',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.transparent,
                        )
                ]),
              ),
            );
          }
          return const Text('');
        });
  }
}
