import 'package:flutter/material.dart';
import 'package:suppgofood/utilities/categ_list.dart';
import 'package:suppgofood/widgets/categ_widgets.dart';

class ThaliCategory extends StatelessWidget {
  const ThaliCategory({Key? key}) : super(key: key);

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
                  headerLabel: 'thali',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: GridView.count(
                    mainAxisSpacing: 70,
                    crossAxisSpacing: 15,
                    crossAxisCount: 3,
                    children: List.generate(thali.length - 1, (index) {
                      return SubcategModel(
                        mainCategName: 'thali',
                        subCategName: thali[index + 1],
                        assetName: 'images/thali/thali$index.jpg',
                        subcategLabel: thali[index + 1],
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
              maincategName: 'thali',
            ))
      ]),
    );
  }
}
