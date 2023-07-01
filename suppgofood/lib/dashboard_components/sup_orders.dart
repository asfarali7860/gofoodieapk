import 'package:flutter/material.dart';
import 'package:suppgofood/dashboard_components/delivered_order.dart';
import 'package:suppgofood/dashboard_components/delivering_order.dart';
import 'package:suppgofood/dashboard_components/preparing_order.dart';
import 'package:suppgofood/widgets/appbar_widget.dart';

class SuppliersOrders extends StatelessWidget {
  const SuppliersOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const AppBarTitle(title: 'Orders'),
            leading: const AppBarBackButton(),
            bottom: const TabBar(
                indicatorColor: Colors.teal,
                indicatorWeight: 6,
                tabs: [
                  RepeatedTab(label: 'Preparing'),
                  RepeatedTab(label: 'Delivering'),
                  RepeatedTab(label: 'Delivered')
                ]),
          ),
          body: const TabBarView(children: [Preparing(),Delivering(), Delivered()])),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
          child: Text(
        label,
        style: const TextStyle(color: Colors.grey),
      )),
    );
  }
}
