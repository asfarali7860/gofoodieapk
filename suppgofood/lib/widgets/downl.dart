import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class ShareWidget extends StatefulWidget {
  final String tableNum;
  final String suppId;
  final dynamic data;
  const ShareWidget(
      {super.key, required this.tableNum, required this.suppId, this.data});

  @override
  State<ShareWidget> createState() => _ShareWidgetState();
}

class _ShareWidgetState extends State<ShareWidget> {
  bool isSaved = false;
  // ignore: prefer_typing_uninitialized_variables
  var qrdataFeed;

  ScreenshotController screenshotcontroller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names, unused_element
    Widget PictureDiv() {
      // ignore: prefer_typing_uninitialized_variables
      var qrBackgroundColor;
      // ignore: prefer_typing_uninitialized_variables
      var qrForegroundColor;
      return Container(
        height: 610,
        width: MediaQuery.of(context).size.width * 1,
        color: const Color.fromARGB(255, 103, 14, 204),
        // padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width * 1,
                          color: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.data['storename'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'GloriaHallelujah',
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      'Table No.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Solitreo',
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      widget.tableNum,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          height: 450,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            image: const DecorationImage(
                                image: AssetImage('assets/food2.jpeg'),
                                fit: BoxFit.cover),
                          ),
                          child: Center(
                            child: Card(
                              borderOnForeground: true,
                              margin: const EdgeInsets.only(
                                left: 65,
                                right: 65,
                                top: 80,
                                bottom: 80,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              color: const Color.fromARGB(255, 255, 225, 116),
                              // color: Colors.transparent,
                              elevation: 10,
                              child: Column(
                                // verticalDirection: VerticalDirection.down,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  QrImage(
                                    //plce where the QR Image will be shown

                                    data: '${widget.suppId}?${widget.tableNum}',
                                    size: 200,
                                    padding: const EdgeInsets.all(20.0),
                                    embeddedImage:
                                        const AssetImage('assets/logo1.png'),
                                    foregroundColor:
                                        qrForegroundColor ?? Colors.black,
                                    backgroundColor:
                                        qrBackgroundColor ?? Colors.white,

                                    eyeStyle: const QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      // color: Color.fromARGB(255, 244, 243, 241),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  const Center(
                                    child: Text(
                                      'SCAN AND ORDER  ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          backgroundColor: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Macondo'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 1,
                              color: Colors.transparent,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                      image: const DecorationImage(
                                          image: AssetImage('assets/logo1.png'),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'GO FOODIE',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Solitreo',
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    // ignore: prefer_typing_uninitialized_variables
    var qrForegroundColor;
    // ignore: prefer_typing_uninitialized_variables
    var qrBackgroundColor;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          title: const Text("QR GEN 2.O"),
          centerTitle: true,
          backgroundColor: Colors.teal,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    screenshotcontroller
                        .captureFromWidget(PictureDiv())
                        .then((image111) {
                      ImageGallerySaver.saveImage(image111);
                      setState(() {
                        isSaved = true;
                      });
                    });
                  },
                  child: isSaved == false
                      ? const Icon(
                          Icons.download,
                          size: 26.0,
                        )
                      : const Icon(
                          Icons.download,
                          size: 26.0,
                          color: Colors.amber,
                        ),
                )),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: 80,
                      color: Colors.transparent,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                widget.data['storename'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'GloriaHallelujah'),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Table No.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Solitreo'),
                                ),
                                Text(
                                  ' ${widget.tableNum}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Lato'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: const DecorationImage(
                            image: AssetImage('assets/food2.jpeg'),
                            fit: BoxFit.cover),
                      ),
                      child: Center(
                        child: Card(
                          borderOnForeground: true,
                          // margin: const EdgeInsets.all(75),
                          margin: const EdgeInsets.only(
                            left: 65,
                            right: 65,
                            top: 80,
                            bottom: 80,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: const Color.fromARGB(255, 255, 225, 116),
                          // color: Colors.transparent,
                          elevation: 10,
                          child: Column(
                            // verticalDirection: VerticalDirection.down,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              QrImage(
                                //plce where the QR Image will be shown

                                data: '${widget.suppId}?${widget.tableNum}',
                                size: 200,
                                padding: const EdgeInsets.all(20.0),
                                embeddedImage:
                                    const AssetImage('assets/logo1.png'),
                                foregroundColor:
                                    qrForegroundColor ?? Colors.black,
                                backgroundColor:
                                    qrBackgroundColor ?? Colors.white,

                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  // color: Color.fromARGB(255, 244, 243, 241),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Center(
                                child: Text(
                                  'SCAN AND ORDER  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      backgroundColor: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Macondo'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 80,
                          color: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/logo1.png'),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'GO FOODIE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Solitreo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 200,
              decoration: const BoxDecoration(color: Colors.white),
            )
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: Colors.grey.shade700),
              onPressed: () {},
              child: const Text('Generate QR code'),
            ),
          ),
        ],
      ),
    );
  }
}
