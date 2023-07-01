import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:suppgofood/widgets/appbar_widget.dart';
import 'package:suppgofood/widgets/downl.dart';

class QrListSCreen extends StatefulWidget {
  final String tableNum;
  final String suppId;
  final dynamic data;
  const QrListSCreen(
      {Key? key, required this.suppId, required this.tableNum, this.data})
      : super(key: key);

  @override
  State<QrListSCreen> createState() => _QrListSCreenState();
}

class _QrListSCreenState extends State<QrListSCreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const AppBarBackButton(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: int.parse(widget.tableNum),
          crossAxisCount: 2,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShareWidget(
                                tableNum: (index + 1).toString(),
                                suppId: widget.suppId,
                                data: widget.data,
                              )));
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Table No. ${index + 1}',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Solitreo',
                            color: Colors.blueGrey.shade700),
                      ),
                      Text(
                        widget.data['storename'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Solitreo',
                            color: Colors.grey.shade700),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
        ),
      ),
    );
  }
}
