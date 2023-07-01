// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gofoodiecust/services/notification_service.dart';
import 'package:gofoodiecust/table/customer_table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gofoodiecust/customer_screen/cust_edit.dart';
import 'package:gofoodiecust/customer_screen/customer_order.dart';
import 'package:gofoodiecust/customer_screen/wishlist.dart';
import 'package:gofoodiecust/minor_screens/update_password.dart';
import 'package:gofoodiecust/widgets/alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  late String documentId;
  ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  String? documentId;

  @override
  void initState() {
    _prefs.then((SharedPreferences prefs) {
      return prefs.getString('customerid') ?? '';
    }).then((String value) {
      setState(() {
        widget.documentId = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return /*Text("Full Name: ${data['full_name']} ${data['last_name']}")*/
              Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 230,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.redAccent, Colors.red.shade300])),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      centerTitle: true,
                      pinned: true,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      expandedHeight: 140,
                      flexibleSpace:
                          LayoutBuilder(builder: (context, constraints) {
                        return FlexibleSpaceBar(
                          title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: constraints.biggest.height <= 120 ? 1 : 0,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.18,
                              ),
                              child: const Text(
                                'Account',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ),
                          background: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.redAccent,
                              Colors.red.shade300
                            ])),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25, left: 30),
                              child: Row(
                                children: [
                                  data['profileimage'] == ''
                                      ? const CircleAvatar(
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              'images/inapp/guest.jpg'),
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                              data['profileimage']),
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 25),
                                    child: Text(
                                      data['name'] == ''
                                          ? 'Guest'.toUpperCase()
                                          : data['name'].toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SliverToBoxAdapter(
                        child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30))),
                                child: TextButton(
                                  child: SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: const Center(
                                      child: Text(
                                        'Orders',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CustomerOrders()));
                                  },
                                ),
                              ),
                              Container(
                                color: Colors.redAccent,
                                child: TextButton(
                                  child: SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: const Center(
                                      child: Text(
                                        'tables',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CustomerTables()));
                                  },
                                ),
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30))),
                                child: TextButton(
                                  child: SizedBox(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    child: const Center(
                                      child: Text(
                                        'Wishlist',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const WishlistScreen()));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.grey.shade300,
                          child: Column(
                            children: [
                              const ProfileHeaderLabel(
                                headerLabel: '  Account Info  ',
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 260,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(children: [
                                    RepeatedListTile(
                                      title: 'Email Address',
                                      subtitle: data['email'] == ''
                                          ? 'example@email.com'
                                          : data['email'],
                                      icon: Icons.email,
                                    ),
                                    const YellowDivider(),
                                    RepeatedListTile(
                                      title: 'Phone No.',
                                      subtitle: data['phone'] == ''
                                          ? '+91'
                                          : data['phone'],
                                      icon: Icons.phone,
                                    ),
                                    const YellowDivider(),
                                    RepeatedListTile(
                                      title: 'Address',
                                      subtitle: data['address'] == ''
                                          ? 'example road, country'
                                          : data['address'],
                                      icon: Icons.location_pin,
                                    ),
                                  ]),
                                ),
                              ),
                              const ProfileHeaderLabel(
                                  headerLabel: '  Account Settings  '),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: 260,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Column(children: [
                                    RepeatedListTile(
                                      title: 'Edit Profile',
                                      icon: Icons.edit,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerEdit(data: data)));
                                      },
                                    ),
                                    const YellowDivider(),
                                    RepeatedListTile(
                                      title: 'Change Password',
                                      icon: Icons.lock,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const UpdatePassword()));
                                      },
                                    ),
                                    const YellowDivider(),
                                    RepeatedListTile(
                                      title: 'Log Out',
                                      icon: Icons.logout,
                                      onPressed: () async {
                                        MyAlertDialog.showMyDialog(
                                            context: context,
                                            title: 'Log Out',
                                            content: 'Are you sure to log out?',
                                            tabNo: () {
                                              Navigator.pop(context);
                                            },
                                            tabYes: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                              final SharedPreferences pref =
                                                  await _prefs;
                                              pref.setString('customerid', '');
                                              await Future.delayed(
                                                      const Duration(
                                                          microseconds: 200))
                                                  .whenComplete(() {
                                                Navigator.pop(context);
                                                Navigator.pushReplacementNamed(
                                                    context, '/welcome_screen');
                                              });
                                            });
                                      },
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
          ),
        );
      },
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.redAccent,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function()? onPressed;
  const RepeatedListTile(
      {Key? key,
      required this.title,
      this.subtitle = '',
      required this.icon,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
          title: Text(title), subtitle: Text(subtitle), leading: Icon(icon)),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

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
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
