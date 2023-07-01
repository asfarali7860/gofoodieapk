import 'package:flutter/material.dart';
import 'package:suppgofood/table/confirmed.dart';
import 'package:suppgofood/table/not_confirmed.dart';
import 'package:suppgofood/widgets/appbar_widget.dart';

class SuppliersTables extends StatelessWidget {
  const SuppliersTables({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
                  RepeatedTab(label: 'Not Confirmed'),
                  RepeatedTab(label: 'Confirmed')
                ]),
          ),
          body: const TabBarView(children: [NotConfirmed(), Confirmed()])),
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
