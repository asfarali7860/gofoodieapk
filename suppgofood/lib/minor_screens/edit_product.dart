// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suppgofood/widgets/yellow_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suppgofood/utilities/categ_list.dart';
import 'package:suppgofood/widgets/snackbar.dart';

class EditProduct extends StatefulWidget {
  final dynamic item;
  const EditProduct({Key? key, required this.item}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String proName;
  late String proDesc;
  late String proId;
  int? discount = 0;
  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';
  List<String> subCategList = [];
  bool processing = false;

  final ImagePicker _picker = ImagePicker();
  List<XFile>? imagesFileList = [];
  List<String>? imagesUrlList = [];
  dynamic _pickImageError;

  void pickProductImages() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imagesFileList = pickedImages;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  void selectMainCateg(String? value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'biryani') {
      subCategList = biryani;
    } else if (value == 'burger') {
      subCategList = burger;
    } else if (value == 'chicken') {
      subCategList = chicken;
    } else if (value == 'pizza') {
      subCategList = pizza;
    } else if (value == 'rolls') {
      subCategList = rolls;
    } else if (value == 'thali') {
      subCategList = thali;
    } else if (value == 'south indian') {
      subCategList = southindian;
    } else if (value == 'dessert') {
      subCategList = dessert;
    }
    print(value);
    setState(() {
      mainCategValue = value!;
      subCategValue = 'subcategory';
    });
  }

  Future uploadImages() async {}

  saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('products')
            .doc(widget.item['proid']);
        transaction.update(documentReference, {
          'price': price,
          'instock': quantity,
          'proname': proName,
          'prodec': proDesc,
          'discount': discount,
        });
      }).whenComplete(() => Navigator.pop(context));
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  Widget previewImages() {
    if (imagesFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imagesFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imagesFileList![index].path));
          });
    } else {
      return const Center(
          child: Text(
        'You have not \n \n picked images yet! ',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ));
    }
  }

  Widget previewCurrentImages() {
    List<dynamic> itemImages = widget.item['proimages'];
    return ListView.builder(
        itemCount: itemImages.length,
        itemBuilder: (context, index) {
          return Image.network(itemImages[index].toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          color: Colors.teal.shade200,
                          height: size.width * 0.5,
                          width: size.width * 0.5,
                          child: previewCurrentImages()),
                      SizedBox(
                        height: size.width * 0.5,
                        width: size.width * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  ' main category',
                                  style: TextStyle(color: Colors.teal),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(8),
                                  constraints: BoxConstraints(
                                      minWidth: size.width * 0.3),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      widget.item['maincateg'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  ' select subcategory',
                                  style: TextStyle(color: Colors.teal),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(8),
                                  constraints: BoxConstraints(
                                      minWidth: size.width * 0.3),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Center(
                                    child: Text(
                                      widget.item['subcateg'],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.redAccent,
                      thickness: 2.5,
                    ),
                  ),
                  // ExpandablePanel(
                  //     theme: const ExpandableThemeData(hasIcon: false),
                  //     header: Padding(
                  //       padding: const EdgeInsets.all(10),
                  //       child: Container(
                  //         constraints: BoxConstraints(
                  //             minWidth: size.width * 0.9, minHeight: 50),
                  //         decoration: BoxDecoration(
                  //             color: Colors.redAccent.shade200,
                  //             borderRadius: BorderRadius.circular(10)),
                  //         child: const Center(
                  //           child: Text(
                  //             'Change Images & Categories',
                  //             style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     collapsed: const SizedBox(),
                  //     expanded: changeImages(size)),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.teal,
                      thickness: 1.5,
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            initialValue:
                                widget.item['price'].toStringAsFixed(2),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter price';
                              } else if (value.isValidPrice() != true) {
                                return 'not valid price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: textFormDecoration.copyWith(
                              labelText: 'price',
                              hintText: 'Rs price..',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TextFormField(
                            initialValue: widget.item['discount'].toString(),
                            maxLength: 2,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return null;
                              } else if (value.isValidDiscount() != true) {
                                return 'not valid price';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              discount = int.parse(value!);
                            },
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: textFormDecoration.copyWith(
                              labelText: 'discount',
                              hintText: 'discount..%',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        initialValue: widget.item['instock'].toString(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter Quantity';
                          } else if (value.isValidQuantity() != true) {
                            return 'not valid quantity';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          quantity = int.parse(value!);
                        },
                        keyboardType: TextInputType.number,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Quantity',
                          hintText: 'Add Quantity',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        initialValue: widget.item['proname'],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter product name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          proName = value!;
                        },
                        maxLength: 100,
                        maxLines: 3,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Name',
                          hintText: 'Enater product name',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        initialValue: widget.item['prodec'],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter product description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          proDesc = value!;
                        },
                        maxLength: 800,
                        maxLines: 5,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Description',
                          hintText: 'Enter product description',
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          YellowButton(
                              label: 'Cancel',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              width: 0.25),
                          YellowButton(
                              label: 'Update',
                              onPressed: () {
                                saveChanges();
                              },
                              width: 0.5)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: YellowButton(
                            label: 'Delete',
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .runTransaction((transaction) async {
                                DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(widget.item['proid']);
                                transaction.delete(documentReference);
                              }).whenComplete(() => Navigator.pop(context));
                            },
                            width: 0.8),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget changeImages(Size size) {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Container(
  //             color: Colors.teal.shade200,
  //             height: size.width * 0.5,
  //             width: size.width * 0.5,
  //             child: imagesFileList != null
  //                 ? previewImages()
  //                 : const Center(
  //                     child: Text(
  //                       'You have not \n \n picked images yet! ',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(fontSize: 16),
  //                     ),
  //                   ),
  //           ),
  //           SizedBox(
  //             height: size.width * 0.5,
  //             width: size.width * 0.5,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Column(
  //                   children: [
  //                     const Text(
  //                       '* select main category',
  //                       style: TextStyle(color: Colors.teal),
  //                     ),
  //                     DropdownButton(
  //                       iconSize: 40,
  //                       iconEnabledColor: Colors.teal,
  //                       dropdownColor: Colors.orangeAccent.shade100,
  //                       value: mainCategValue,
  //                       items: maincateg.map<DropdownMenuItem<String>>((value) {
  //                         return DropdownMenuItem(
  //                           value: value,
  //                           child: Text(value),
  //                         );
  //                       }).toList(),
  //                       onChanged: (String? value) {
  //                         selectMainCateg(value);
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //                 Column(
  //                   children: [
  //                     const Text(
  //                       '* select subcategory',
  //                       style: TextStyle(color: Colors.teal),
  //                     ),
  //                     DropdownButton(
  //                       iconSize: 40,
  //                       iconEnabledColor: Colors.teal,
  //                       dropdownColor: Colors.orangeAccent.shade100,
  //                       iconDisabledColor: Colors.black,
  //                       menuMaxHeight: 500,
  //                       disabledHint: const Text('select category'),
  //                       value: subCategValue,
  //                       items:
  //                           subCategList.map<DropdownMenuItem<String>>((value) {
  //                         return DropdownMenuItem(
  //                           value: value,
  //                           child: Text(value),
  //                         );
  //                       }).toList(),
  //                       onChanged: (String? value) {
  //                         print(value);
  //                         setState(
  //                           () {
  //                             subCategValue = value!;
  //                           },
  //                         );
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: imagesFileList!.isNotEmpty
  //             ? YellowButton(
  //                 label: 'Reset Images',
  //                 onPressed: () {
  //                   setState(() {
  //                     imagesFileList = [];
  //                   });
  //                 },
  //                 width: 0.6)
  //             : YellowButton(
  //                 label: 'Change Images',
  //                 onPressed: () {
  //                   pickProductImages();
  //                 },
  //                 width: 0.6),
  //       )
  //     ],
  //   );
  // }
}

var textFormDecoration = InputDecoration(
    labelText: 'price',
    hintText: 'Rs price..',
    labelStyle: const TextStyle(color: Colors.teal),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10)));

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}

extension DiscountValidator on String {
  bool isValidDiscount() {
    return RegExp(r'^([0-9])$').hasMatch(this);
  }
}
