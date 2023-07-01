import 'package:flutter/material.dart';
import 'package:gofoodiecust/categories/southindian_category.dart';
import 'package:gofoodiecust/categories/dessert_category.dart';
import 'package:gofoodiecust/categories/thali.dart';
import 'package:gofoodiecust/categories/chicken_category.dart';
import 'package:gofoodiecust/categories/rolls_category.dart';
import 'package:gofoodiecust/categories/chinese.dart';
import 'package:gofoodiecust/categories/biryani_category.dart';
import 'package:gofoodiecust/categories/pizza_category.dart';
import 'package:gofoodiecust/categories/burger_category.dart';
import 'package:gofoodiecust/widgets/fake_search.dart';

List<ItemsData> items = [
  ItemsData(label: 'biryani'),
  ItemsData(label: 'burger'),
  ItemsData(label: 'chicken'),
  ItemsData(label: 'pizza'),
  ItemsData(label: 'rolls'),
  ItemsData(label: 'thali'),
  ItemsData(label: 'south indian'),
  ItemsData(label: 'chinese'),
  ItemsData(label: 'dessert'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    for (var element in items) {
      element.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const FakeSearch(),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(size)),
          Positioned(bottom: 0, right: 0, child: categView(size)),
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.21,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.bounceInOut);
              },
              child: Container(
                  color: items[index].isSelected == true
                      ? Colors.white
                      : Colors.red.shade200,
                  height: 75,
                  child: Center(
                    child: Text(items[index].label),
                  )),
            );
          }),
    );
  }

  Widget categView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.79,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var element in items) {
            element.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          BiryaniCategory(),
          BurgerCategory(),
          ChickenCategory(),
          PizzaCategory(),
          RollsCategory(),
          ThaliCategory(),
          SouthIndianCategory(),
          ChineseCategory(),
          DessertCategory(),
        ],
      ),
    );
  }
}

class ItemsData {
  String label;
  bool isSelected;
  ItemsData({required this.label, this.isSelected = false});
}
