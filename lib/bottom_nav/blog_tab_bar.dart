import 'package:flutter/material.dart';
import 'package:kzn/bottom_nav/famous.dart';
import 'package:kzn/bottom_nav/history.dart';
import 'drawing.dart';
import 'others.dart';
import 'color.dart';
import 'famous.dart';

class BlogTab extends StatefulWidget {
  @override
  _BlogTabState createState() => _BlogTabState();
}

class _BlogTabState extends State<BlogTab>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Widget getTabBar() {
    return TabBar(controller: tabController,
        indicatorColor: Colors.black,
        labelColor: Colors.black,
        labelStyle: TextStyle(fontSize: 10),
        tabs: [
            Tab(icon: Icon(Icons.color_lens_outlined, color: Colors.black), text: 'Color'),
            Tab(icon: Icon(Icons.group_outlined, color: Colors.black), text: 'Famous'),
            Tab(icon: Icon(Icons.create_outlined, color: Colors.black), text: 'Drawing'),
            Tab(icon: Icon(Icons.military_tech_outlined, color: Colors.black), text: 'History'),
            Tab(icon: Icon(Icons.public_outlined, color: Colors.black), text: 'Others'),
    ]);
  }

  Widget getTabBarPages() {
    return TabBarView(controller: tabController, children: <Widget>[
          Color(),
          Famous(),
          Drawing(),
          History(),
          Others(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: getTabBar(),
          ),
        ),
        body: getTabBarPages( ));
  }
}


