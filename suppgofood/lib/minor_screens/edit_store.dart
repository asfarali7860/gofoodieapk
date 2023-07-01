// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suppgofood/main_screens/supplier_home.dart';
import 'package:suppgofood/widgets/appbar_widget.dart';
import 'package:suppgofood/widgets/snackbar.dart';
import 'package:suppgofood/widgets/yellow_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditStore extends StatefulWidget {
  final dynamic data;
  const EditStore({super.key, required this.data});

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  XFile? imageFileLogo;
  XFile? imageFileCover;
  dynamic _pickImageError;
  late String storeName;
  late String phone;
  late String storeLogo;
  late String address;
  late String coverImage;
  List<geocoding.Placemark>? placemark;
  LocationData? locationData;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  void getPermission() async {
    if (await Permission.location.isGranted) {
      //get location
      getLocation();
    } else {
      Permission.location.request();
    }
  }

  void getLocation() async {
    setState(() {
      isLoading = true;
    });
    locationData = await Location.instance.getLocation();
    placemark = await geocoding.placemarkFromCoordinates(
        locationData!.latitude!, locationData!.longitude!);
    setState(() {
      isLoading = false;
    });
  }

  bool processing = false;
  pickStoreLogo() async {
    try {
      final pickedStoreLogo = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFileLogo = pickedStoreLogo;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  pickCoverImage() async {
    try {
      final pickedCoverImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFileCover = pickedCoverImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  Future uploadStoreLogo() async {
    if (imageFileLogo != null) {
      try {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg');

        await ref.putFile(File(imageFileLogo!.path));
        storeLogo = await ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      storeLogo = widget.data['storelogo'];
    }
  }

  Future uploadCoverImage() async {
    if (imageFileCover != null) {
      try {
        firebase_storage.Reference ref2 = firebase_storage
            .FirebaseStorage.instance
            .ref('supp-images/${widget.data['email']}.jpg-cover');

        await ref2.putFile(File(imageFileCover!.path));
        coverImage = await ref2.getDownloadURL();
      } catch (e) {
        print(e);
      }
    } else {
      coverImage = widget.data['coverimage'];
    }
  }

  editStoreData() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('suppliers')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      transaction.update(documentReference, {
        'storename': storeName,
        'phone': phone,
        'storelogo': storeLogo,
        'coverimage': coverImage,
        'address':
            '${placemark![0].subThoroughfare}, ${placemark![0].thoroughfare}, ${placemark![0].subLocality}, ${placemark![0].locality}, ${placemark![0].subAdministrativeArea}, ${placemark![0].administrativeArea}, ${placemark![0].country}'
      });
    }).whenComplete(() => Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SupplierHomeScreen())));
  }

  saveChanges() async {
    if (_formKey.currentState!.validate()) {
      if (placemark != null) {
        _formKey.currentState!.save();
        setState(() {
          processing = true;
        });
        await uploadStoreLogo().whenComplete(() async =>
            await uploadCoverImage().whenComplete(() async => editStoreData()));
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'please click on loaction icon');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarTitle(
            title: '    Edit Store',
          ),
          leading: const AppBarBackButton(),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            reverse: true,
            child: Column(
              children: [
                const Text(
                  'Store logo',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(widget.data['storelogo']),
                    ),
                    Column(
                      children: [
                        YellowButton(
                            label: 'change',
                            onPressed: () {
                              pickStoreLogo();
                            },
                            width: 0.25),
                        const SizedBox(
                          height: 10,
                        ),
                        imageFileLogo == null
                            ? const SizedBox()
                            : YellowButton(
                                label: 'reset',
                                onPressed: () {
                                  setState(() {
                                    imageFileLogo = null;
                                  });
                                },
                                width: 0.25),
                      ],
                    ),
                    imageFileLogo == null
                        ? const SizedBox()
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                FileImage(File(imageFileLogo!.path)),
                          )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(
                    color: Colors.redAccent,
                    thickness: 2.5,
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      'Cover Image',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        widget.data['coverimage'] == ''
                            ? const CircleAvatar(
                                radius: 60,
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    NetworkImage(widget.data['coverimage']),
                              ),
                        Column(
                          children: [
                            YellowButton(
                                label: 'change',
                                onPressed: () {
                                  pickCoverImage();
                                },
                                width: 0.25),
                            const SizedBox(
                              height: 10,
                            ),
                            imageFileCover == null
                                ? const SizedBox()
                                : YellowButton(
                                    label: 'reset',
                                    onPressed: () {
                                      setState(() {
                                        imageFileCover = null;
                                      });
                                    },
                                    width: 0.25),
                          ],
                        ),
                        imageFileCover == null
                            ? const SizedBox()
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    FileImage(File(imageFileCover!.path)),
                              )
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(
                    color: Colors.redAccent,
                    thickness: 2.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please Enter store name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      storeName = value!;
                    },
                    initialValue: widget.data['storename'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'store name', hintText: 'Enter Store Name'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please Enter Phone Number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phone = value!;
                    },
                    initialValue: widget.data['phone'],
                    decoration: textFormDecoration.copyWith(
                        labelText: 'phone number',
                        hintText: 'Enter Phone Number'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all()),
                        child: placemark != null
                            ? Center(
                                child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${placemark![0].subThoroughfare}, ${placemark![0].thoroughfare}, ${placemark![0].subLocality}, ${placemark![0].locality}, ${placemark![0].subAdministrativeArea}, ${placemark![0].administrativeArea}, ${placemark![0].country}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  widget.data['address'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                              ),
                      ),
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : IconButton(
                              color: Colors.redAccent,
                              onPressed: getPermission,
                              icon: const Icon(Icons.location_pin))
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      YellowButton(
                          label: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          width: 0.25),
                      processing == true
                          ? YellowButton(
                              label: 'Wait ..',
                              onPressed: () {
                                null;
                              },
                              width: 0.5)
                          : YellowButton(
                              label: 'Update',
                              onPressed: () {
                                saveChanges();
                              },
                              width: 0.5)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
    labelText: 'Full Name',
    hintText: 'Enter your full name',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        borderRadius: BorderRadius.circular(25)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(25)));
