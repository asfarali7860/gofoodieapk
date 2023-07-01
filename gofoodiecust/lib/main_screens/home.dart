// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gofoodiecust/galleries/biryani_gallery.dart';
import 'package:gofoodiecust/galleries/burger_gallery.dart';
import 'package:gofoodiecust/galleries/chicken_gallery.dart';
import 'package:gofoodiecust/galleries/chinese_gallery.dart';
import 'package:gofoodiecust/galleries/dessert_gallery.dart';
import 'package:gofoodiecust/galleries/pizza_gallery.dart';
import 'package:gofoodiecust/galleries/rolls_gallery.dart';
import 'package:gofoodiecust/galleries/southindian_gallery.dart';
import 'package:gofoodiecust/galleries/thali_gallery.dart';
import 'package:gofoodiecust/main_screens/visit_store.dart';
import 'package:gofoodiecust/providers/cart_provider.dart';
import 'package:gofoodiecust/widgets/fake_search.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final dynamic placemark;
  const HomeScreen({Key? key, this.placemark}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var getResult = 'QR Code Result';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const FakeSearch(),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.redAccent,
            indicatorWeight: 5,
            tabs: [
              RepeatedTab(label: 'biryani'),
              RepeatedTab(label: 'burger'),
              RepeatedTab(label: 'chicken'),
              RepeatedTab(label: 'pizza'),
              RepeatedTab(label: 'rolls'),
              RepeatedTab(label: 'thali'),
              RepeatedTab(label: 'south indian'),
              RepeatedTab(label: 'chinese'),
              RepeatedTab(label: 'dessert'),
            ],
          ),
        ),
        floatingActionButton: DraggableFab(
          child: FloatingActionButton.extended(
            label: const Text('QR Scanner'),
            isExtended: true,
            tooltip: 'Scanner',
            backgroundColor: Colors.redAccent.shade700,
            onPressed: () {
              scanQRCode();
            },
            icon: const Icon(
              Icons.qr_code,
              color: Colors.white,
            ),
          ),
        ),
        body: const TabBarView(children: [
          BiryaniGalleryScreen(),
          BurgerGalleryScreen(),
          ChickenGalleryScreen(),
          PizzaGalleryScreen(),
          RollsGalleryScreen(),
          ThaliGalleryScreen(),
          SouthIndianGalleryScreen(),
          ChineseGalleryScreen(),
          DessertGalleryScreen(),
        ]),
        // bottomSheet: Padding(
        //   padding: const EdgeInsets.only(
        //     right: 10,
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Container(
        //           alignment: Alignment.bottomRight,
        //           height: 40,
        //           width: 135,
        //           decoration: BoxDecoration(
        //               color: Colors.redAccent,
        //               shape: BoxShape.rectangle,
        //               borderRadius: BorderRadius.circular(25)),
        //           child: MaterialButton(
        //             onPressed: () {},
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: const [
        //                 Icon(FontAwesomeIcons.robot),
        //                 Text(
        //                   'Ask Me',
        //                   style: TextStyle(
        //                       fontSize: 16,
        //                       fontWeight: FontWeight.bold,
        //                       color: Colors.white),
        //                 )
        //               ],
        //             ),
        //           )),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (!mounted) return;
      List<String> strarray = qrCode.split("?");
      setState(() {
        context.read<Cart>().clearCart();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VisitStore(
                      suppId: strarray[0],
                      tablenum: strarray[1],
                      isQr: 'odine',
                    )));
      });
    } on PlatformException {
      getResult = 'Failed to scan QR Code.';
    }
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
