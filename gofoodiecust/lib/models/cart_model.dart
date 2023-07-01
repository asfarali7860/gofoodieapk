// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gofoodiecust/providers/cart_provider.dart';
import 'package:gofoodiecust/providers/product_class.dart';
import 'package:gofoodiecust/providers/wish_provider.dart';
import 'package:provider/provider.dart';

class CartModel extends StatelessWidget {
  const CartModel({Key? key, required this.product, required this.cart})
      : super(key: key);

  final Product product;
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        child: SizedBox(
          height: 120,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(children: [
            SizedBox(
              height: 100,
              width: 120,
              child: Image.network(product.imagesUrl.first),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.price.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red.shade700),
                        ),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            children: [
                              product.qty == 1
                                  ? IconButton(
                                      onPressed: () {
                                        showCupertinoModalPopup<void>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoActionSheet(
                                            title: const Text('Remove Item'),
                                            message: const Text(
                                                'Are you sure to remove this item ?'),
                                            actions: <
                                                CupertinoActionSheetAction>[
                                              CupertinoActionSheetAction(
                                                /// This parameter indicates the action would be a default
                                                /// defualt behavior, turns the action's text to bold text.
                                                isDefaultAction: true,
                                                onPressed: () async {
                                                  context
                                                              .read<Wish>()
                                                              .getWishItems
                                                              .firstWhereOrNull(
                                                                  (element) =>
                                                                      element
                                                                          .documentId ==
                                                                      product
                                                                          .documentId) !=
                                                          null
                                                      ? context
                                                          .read<Cart>()
                                                          .removeItem(product)
                                                      : await context
                                                          .read<Wish>()
                                                          .addWishItem(
                                                            product.name,
                                                            product.price,
                                                            1,
                                                            product.qntty,
                                                            product.imagesUrl,
                                                            product.documentId,
                                                            product.suppId,
                                                          );
                                                  context
                                                      .read<Cart>()
                                                      .removeItem(product);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Move Item'),
                                              ),
                                              CupertinoActionSheetAction(
                                                /// This parameter indicates the action would be a default
                                                /// defualt behavior, turns the action's text to bold text.
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  context
                                                      .read<Cart>()
                                                      .removeItem(product);
                                                  Navigator.pop(context);
                                                },
                                                child:
                                                    const Text('Delete Item'),
                                              ),
                                              CupertinoActionSheetAction(
                                                /// This parameter indicates the action would perform
                                                /// a destructive action such as delete or exit and turns
                                                /// the action's text color to red.
                                                isDestructiveAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('cancel'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_forever,
                                        size: 18,
                                      ))
                                  : IconButton(
                                      onPressed: () {
                                        cart.decreament(product);
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.minus,
                                        size: 18,
                                      )),
                              Text(product.qty.toString(),
                                  style: product.qty == product.qntty
                                      ? const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Acme',
                                          color: Colors.red)
                                      : const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Acme',
                                          fontWeight: FontWeight.w500,
                                        )),
                              IconButton(
                                  onPressed: product.qty == product.qntty
                                      ? null
                                      : () {
                                          cart.increament(product);
                                        },
                                  icon: const Icon(
                                    FontAwesomeIcons.plus,
                                    size: 18,
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
