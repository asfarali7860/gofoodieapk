import 'package:gofoodiecust/table/detailtable.dart';
import 'package:gofoodiecust/widgets/appbar_widget.dart';
import 'package:gofoodiecust/widgets/yellow_button.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class BookTable extends StatefulWidget {
  final dynamic data;
  const BookTable({super.key, required this.data});

  @override
  State<BookTable> createState() => _BookTableState();
}

class _BookTableState extends State<BookTable> {
  late String bookingtime = ' ';
  late String errormessage = ' ';
  bool onpress = false;
  String orderdate =
      DateFormat.yMMMd().format(DateTime.now().add(const Duration(days: 1)));
  String day =
      DateFormat.EEEE().format(DateTime.now().add(const Duration(days: 1)));
  String ordertime = DateFormat("hh:mm:ss a").format(DateTime.now());
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  List<String> label = [
    '10:30 am',
    '12:00 pm',
    '01:30 pm',
    '03:00 pm',
    '04:30 pm',
    '06:00 pm',
    '07:30 pm',
    '09:00 pm'
  ];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 150,
              flexibleSpace: widget.data['coverimage'] == ''
                  ? Image.asset(
                      'images/inapp/coverimage.jpg',
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.data['coverimage'],
                      fit: BoxFit.cover,
                    ),
              leading: const TealBackButton(),
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.teal),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.network(
                        widget.data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Text(
                                widget.data['storename'].toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: ScaffoldMessenger(
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () {}),
                  toolbarHeight: 250,
                  backgroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                  title: Row(
                    children: [
                      const SizedBox(
                        width: 33,
                      ),
                      Column(
                        children: [
                          Text(day,
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          Text(
                            orderdate,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GridView.count(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 4,
                    children: List.generate(8, (index) {
                      return InkWell(
                        onTap: () {
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: bookingtime != label[index]
                              ? MaterialButton(
                                  color: Colors.blue,
                                  splashColor: Colors.green,
                                  highlightColor: Colors.red,
                                  focusColor: Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      bookingtime = label[index];
                                      onpress = true;
                                    });
                                  },
                                  child: Text(
                                    label[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                        fontFamily: 'Acme'),
                                  ),
                                )
                              : MaterialButton(
                                  color: Colors.red,
                                  splashColor: Colors.green,
                                  highlightColor: Colors.red,
                                  focusColor: Colors.black,
                                  onPressed: () {},
                                  child: Text(
                                    label[index],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                        fontFamily: 'Acme'),
                                  ),
                                ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: onpress == true
                      ? YellowButton(
                          label: 'Book Table',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailedTable(
                                        data: widget.data,
                                        time: bookingtime,
                                        date: orderdate)));
                          },
                          width: 0.45)
                      : YellowButton(
                          label: 'Book Table', onPressed: () {}, width: 0.45),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  var emailFormDecoration = InputDecoration(
      labelText: 'Full Name',
      hintText: 'Enter your full name',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          borderRadius: BorderRadius.circular(25)),
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
          borderRadius: BorderRadius.circular(25)));
}

extension TableValidator on String {
  bool isValidTableNumber() {
    return RegExp(r'^([0-9]{1,2})$').hasMatch(this);
  }
}
