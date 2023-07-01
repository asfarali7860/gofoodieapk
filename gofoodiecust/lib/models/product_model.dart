import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gofoodiecust/main_screens/visit_store.dart';
import 'package:gofoodiecust/minor_screens/product_details.dart';
import 'package:gofoodiecust/providers/cart_provider.dart';
import 'package:gofoodiecust/providers/wish_provider.dart';
import 'package:gofoodiecust/widgets/snackbar.dart';
import 'package:gofoodiecust/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

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
                                  IconButton(
                                          onPressed: () {
                                            var existingItemWishlist = context
                                                .read<Wish>()
                                                .getWishItems
                                                .firstWhereOrNull((product) =>
                                                    product.documentId ==
                                                    widget.products['proid']);
                                            existingItemWishlist != null
                                                ? context
                                                    .read<Wish>()
                                                    .removeThis(widget
                                                        .products['proid'])
                                                : context
                                                    .read<Wish>()
                                                    .addWishItem(
                                                      widget
                                                          .products['proname'],
                                                      widget.products[
                                                                  'discount'] !=
                                                              0
                                                          ? ((1 -
                                                                  (widget.products[
                                                                          'discount'] /
                                                                      100)) *
                                                              widget.products[
                                                                  'price'])
                                                          : widget.products[
                                                              'price'],
                                                      1,
                                                      widget
                                                          .products['instock'],
                                                      widget.products[
                                                          'proimages'],
                                                      widget.products['proid'],
                                                      widget.products['sid'],
                                                    );
                                          },
                                          icon: context
                                                      .watch<Wish>()
                                                      .getWishItems
                                                      .firstWhereOrNull(
                                                          (product) =>
                                                              product
                                                                  .documentId ==
                                                              widget.products[
                                                                  'proid']) !=
                                                  null
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 30,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .favorite_border_outlined,
                                                  color: Colors.red,
                                                  size: 30,
                                                ),
                                        ),
                                ],
                              ),
                              // widget.products['sid'] ==
                              //         FirebaseAuth.instance.currentUser!.uid
                              widget.isQr == 'odine'
                                  ? YellowButton(
                                      label: context
                                                  .read<Cart>()
                                                  .getItems
                                                  .firstWhereOrNull((product) =>
                                                      product.documentId ==
                                                      widget
                                                          .products['proid']) !=
                                              null
                                          ? 'Added to Cart'
                                          : 'Add to Cart',
                                      onPressed: () {
                                        var existingItemCart = context
                                            .read<Cart>()
                                            .getItems
                                            .firstWhereOrNull((product) =>
                                                product.documentId ==
                                                widget.products['proid']);
                                        if (widget.products['instock'] == 0) {
                                          MyMessageHandler.showSnackBar(
                                              _scaffoldKey,
                                              'this item is out of stock');
                                        } else if (existingItemCart != null) {
                                          MyMessageHandler.showSnackBar(
                                              _scaffoldKey,
                                              'this item already in cart');
                                        } else {
                                          context.read<Cart>().addItem(
                                                widget.products['proname'],
                                                widget.products['price'],
                                                1,
                                                widget.products['instock'],
                                                widget.products['proimages'],
                                                widget.products['proid'],
                                                widget.products['sid'],
                                              );
                                        }
                                      },
                                      width: 0.45,
                                    )
                                  : InkWell(
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
