import 'package:flutter/material.dart';
import 'package:gofoodiecust/utilities/categ_list.dart';
import 'package:gofoodiecust/widgets/categ_widgets.dart';

class BurgerCategory extends StatelessWidget {
  const BurgerCategory({Key? key}) : super(key: key);

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
                  headerLabel: 'burger',
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: GridView.count(
                    mainAxisSpacing: 70,
                    crossAxisSpacing: 15,
                    crossAxisCount: 3,
                    children: List.generate(burger.length - 1, (index) {
                      return SubcategModel(
                        mainCategName: 'burger',
                        subCategName: burger[index + 1],
                        assetName: 'images/burger/burger$index.jpeg',
                        subcategLabel: burger[index + 1],
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
              maincategName: 'burger',
            ))
      ]),
    );
  }
}
