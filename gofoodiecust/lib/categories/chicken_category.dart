import 'package:flutter/material.dart';
import 'package:gofoodiecust/utilities/categ_list.dart';
import 'package:gofoodiecust/widgets/categ_widgets.dart';

class ChickenCategory extends StatelessWidget {
  const ChickenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.74,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CategHeaderLabel(
                  headerLabel: 'chicken',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: GridView.count(
                    mainAxisSpacing: 70,
                    crossAxisSpacing: 15,
                    crossAxisCount: 3,
                    children: List.generate(chicken.length - 1, (index) {
                      return SubcategModel(
                        mainCategName: 'chicken',
                        subCategName: chicken[index + 1],
                        assetName: 'images/chicken/chicken$index.jpeg',
                        subcategLabel: chicken[index + 1],
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
        const Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              maincategName: 'chicken',
            ))
      ]),
    );
  }
}
