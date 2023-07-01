// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:suppgofood/providers/auth_repo.dart';
import 'package:suppgofood/widgets/auth_widgets.dart';
import 'package:suppgofood/widgets/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// final TextEditingController _namecontroller = TextEditingController();
// final TextEditingController _emailcontroller = TextEditingController();
// final TextEditingController _passwordcontroller = TextEditingController();

class SupplierRegister extends StatefulWidget {
  const SupplierRegister({Key? key}) : super(key: key);

  @override
  State<SupplierRegister> createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {
  late String storeName;
  late String email;
  late String password;
  late String storeLogo;
  List<geocoding.Placemark>? placemark;
  late String _uid;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickImageError;
  LocationData? locationData;
  bool isLoading = false;

  CollectionReference suppliers =
      FirebaseFirestore.instance.collection('suppliers');

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

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  void signUp() async {
    setState(() {
      processing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (placemark != null) {
        if (_imageFile != null) {
          try {
            await AuthRepo.signUpWithEmailAndPassword(email, password);
            AuthRepo.sendEmailVerification();

            firebase_storage.Reference ref = firebase_storage
                .FirebaseStorage.instance
                .ref('supp-images/$email.jpg');

            await ref.putFile(File(_imageFile!.path));
            storeLogo = await ref.getDownloadURL();

            AuthRepo.updateUserName(storeName);
            AuthRepo.updateProfileImage(storeLogo);

            _uid = AuthRepo.uid;

            await suppliers.doc(_uid).set({
              'storename': storeName,
              'email': email,
              'storelogo': storeLogo,
              'phone': '',
              'locality': placemark![0].locality,
              'area': placemark![0].subAdministrativeArea,
              'state': placemark![0].administrativeArea,
              'country': placemark![0].country,
              'address':
                  '${placemark![0].subThoroughfare}, ${placemark![0].thoroughfare}, ${placemark![0].subLocality}, ${placemark![0].locality}, ${placemark![0].subAdministrativeArea}, ${placemark![0].administrativeArea}, ${placemark![0].country}',
              'sid': _uid,
              'tokens': '',
              'coverimage': ''
            });

            _formKey.currentState!.reset();
            setState(() {
              _imageFile = null;
            });
            Navigator.pushReplacementNamed(context, '/supplier_login');
          } on FirebaseAuthException catch (e) {
            setState(() {
              processing = false;
            });
            MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());

            // setState(() {
            //     processing = false;
            //   });
            // if (e.code == 'weak-password') {
            //   setState(() {
            //     processing = false;
            //   });
            //   MyMessageHandler.showSnackBar(
            //       _scaffoldKey, 'The password provided is too weak');
            // } else if (e.code == 'email-already-in-use') {
            //   setState(() {
            //     processing = false;
            //   });
            //   MyMessageHandler.showSnackBar(
            //       _scaffoldKey, 'The account already exists for that email');
            // }
          }
        } else {
          setState(() {
            processing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, 'Please pick image');
        }
      } else {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'please click on loaction icon');
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AuthHeaderLabel(
                        headerLabel: 'Sign Up',
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.redAccent.shade100,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.redAccent.shade100,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImageFromCamera();
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.redAccent.shade100,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _pickImageFromGallery();
                                  },
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your full name';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              storeName = value;
                            },
                            // controller: _namecontroller,
                            decoration: textFormDecoration.copyWith(
                                labelText: 'Full Name',
                                hintText: 'Enter your full name')),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your email';
                              } else if (value.isValidEmail() == false) {
                                return 'invalid email';
                              } else if (value.isValidEmail() == true) {
                                return null;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              email = value;
                            },
                            // controller: _emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: textFormDecoration.copyWith(
                                labelText: 'Email Address',
                                hintText: 'Enter your email')),
                      ),
                      Row(
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
                                      '${placemark![0].locality}, ${placemark![0].subAdministrativeArea}, ${placemark![0].administrativeArea}, ${placemark![0].country}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                                : Center(
                                    child: Text(
                                    'Click on location pin',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            // controller: _passwordcontroller,
                            obscureText: passwordVisible,
                            decoration: textFormDecoration.copyWith(
                                suffix: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.redAccent,
                                    )),
                                labelText: 'Password',
                                hintText: 'Enter your password')),
                      ),
                      HaveAccount(
                        haveAccount: 'already have account? ',
                        actionLabel: 'Log In',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_login');
                        },
                      ),
                      processing == true
                          ? const CircularProgressIndicator(
                              color: Colors.teal,
                            )
                          : AuthMainButton(
                              mainButtonLabel: 'Sign Up',
                              onPressed: () {
                                signUp();
                              },
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
