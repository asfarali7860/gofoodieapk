// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:gofoodiecust/main_screens/cart.dart';
import 'package:gofoodiecust/main_screens/visit_store.dart';
import 'package:gofoodiecust/models/product_model.dart';
import 'package:gofoodiecust/providers/cart_provider.dart';
import 'package:gofoodiecust/providers/wish_provider.dart';
import 'package:gofoodiecust/widgets/appbar_widget.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;
import 'package:expandable/expandable.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
      .collection('products')
      .where('maincateg', isEqualTo: widget.proList['maincateg'])
      .where('subcateg', isEqualTo: widget.proList['subcateg'])
      .snapshots();

  late final Stream<QuerySnapshot> reviewsStream = FirebaseFirestore.instance
      .collection('products')
      .doc(widget.proList['proid'])
      .collection('reviews')
      .limit(3)
      .snapshots();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late List<dynamic> imageList = widget.proList['proimages'];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: Swiper(
                            pagination: const SwiperPagination(
                                builder: SwiperPagination.fraction),
                            itemBuilder: (context, index) {
                              return Image(
                                  image: NetworkImage(imageList[index]));
                            },
                            itemCount: imageList.length),
                      ),
                      Positioned(
                          left: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )),
                      Positioned(
                          right: 15,
                          top: 20,
                          child: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () {},
                            ),
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.proList['proname'],
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Rs ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.proList['price'].toStringAsFixed(2),
                              style: widget.proList['discount'] != 0
                                  ? const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 8,
                                      decoration: TextDecoration.lineThrough,
                                      fontWeight: FontWeight.w600,
                                    )
                                  : TextStyle(
                                      color: Colors.red.shade600,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            widget.proList['discount'] != 0
                                ? Text(
                                    ((1 - (widget.proList['discount'] / 100)) *
                                            widget.proList['price'])
                                        .toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.red.shade600,
                                      fontSize: 20,
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
                                    widget.proList['proid']);
                            existingItemWishlist != null
                                ? context
                                    .read<Wish>()
                                    .removeThis(widget.proList['proid'])
                                : context.read<Wish>().addWishItem(
                                      widget.proList['proname'],
                                      widget.proList['discount'] != 0
                                          ? ((1 -
                                                  (widget.proList['discount'] /
                                                      100)) *
                                              widget.proList['price'])
                                          : widget.proList['price'],
                                      1,
                                      widget.proList['instock'],
                                      widget.proList['proimages'],
                                      widget.proList['proid'],
                                      widget.proList['sid'],
                                    );
                          },
                          icon: context
                                      .watch<Wish>()
                                      .getWishItems
                                      .firstWhereOrNull((product) =>
                                          product.documentId ==
                                          widget.proList['proid']) !=
                                  null
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.red,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ),
                  widget.proList['instock'] == 0
                      ? const Text(
                          'This item is out of stock',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 10,
                          ),
                        )
                      : Text(
                          (widget.proList['instock'].toString()) +
                              (' plate available'),
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 10,
                          ),
                        ),
                  const ProDetailsHeader(
                    label: '  Food Description  ',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.proList['prodec'],
                      textScaleFactor: 1.2,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const ProDetailsHeader(
                    label: '  Reviews  ',
                  ),
                  ExpandableTheme(
                      data: const ExpandableThemeData(
                          iconSize: 30, iconColor: Colors.blue),
                      child: reviewsAll(reviewsStream)),
                  const ProDetailsHeader(
                    label: '  Similar Food  ',
                  ),
                  SizedBox(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _productStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return const Center(
                              child: Text(
                            'This category \n\n has no items yet !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Acme',
                              letterSpacing: 1.5,
                            ),
                          ));
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
                              );
                            },
                            staggeredTileBuilder: (context) =>
                                const StaggeredTile.fit(1),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VisitStore(suppId: widget.proList['sid'])));
                    },
                    icon: const Icon(
                      Icons.store,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen(
                                    back: AppBarBackButton(),
                                  )));
                    },
                    icon: badges.Badge(
                      showBadge:
                          context.read<Cart>().getItems.isEmpty ? false : true,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProDetailsHeader extends StatelessWidget {
  final String label;
  const ProDetailsHeader({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.blue,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
                color: Colors.blue, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.blue,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

Widget reviews(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
      stream: reviewsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
        if (snapshot2.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot2.data!.docs.isEmpty) {
          return const Center(
              child: Text(
            '',
          ));
        }

        return ExpandablePanel(
            header: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                ('Reviews (') + snapshot2.data!.docs.length.toString() + (')'),
                style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            collapsed: SizedBox(
              height: 230,
              child: reviewsAll(reviewsStream),
            ),
            expanded: reviewsAll(reviewsStream));
      });
}

Widget reviewsAll(var reviewsStream) {
  return StreamBuilder<QuerySnapshot>(
    stream: reviewsStream,
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
      if (snapshot2.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot2.data!.docs.isEmpty) {
        return const Center(
            child: Text(
          'Not reviewed yet',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontFamily: 'Acme',
            letterSpacing: 1.5,
          ),
        ));
      }

      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot2.data!.docs[index]['profileimage'])),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snapshot2.data!.docs[index]['name']),
                  Row(
                    children: [
                      Text(snapshot2.data!.docs[index]['rate'].toString()),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      )
                    ],
                  )
                ],
              ),
              subtitle: Text(snapshot2.data!.docs[index]['comment']),
            );
          });
    },
  );
}
