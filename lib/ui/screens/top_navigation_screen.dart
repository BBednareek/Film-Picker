import 'package:filmapp/data/model/top_navigation_item.dart';
import 'package:flutter/material.dart';

class TopNavigationScreen extends StatelessWidget {
  static const String id = 'top_navigation_screen';
  final List<TopNavigationItem> navigationItems = [
    TopNavigationItem(screen: ProfileScreen(), iconData: Icons.person),
    TopNavigationItem(screen: ChatsScreen(), iconData: Icons.message_rounded),
    TopNavigationItem(screen: MatchScreen(), iconData: Icons.favorite)
  ];

  TopNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var tabBar = TabBar(
      tabs: navigationItems
          .map(
            (navItem) => SizedBox(
              height: double.infinity,
              child: Tab(
                icon: Icon(
                  navItem.iconData,
                  size: 26,
                ),
              ),
            ),
          )
          .toList(),
    );

    var appBar = AppBar(flexibleSpace: tabBar);
    final tabBarHeight = tabBar.preferredSize.height;
    final appBarHeight = appBar.preferredSize.height;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: navigationItems.length,
      child: SafeArea(
          child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
              height: height - tabBarHeight - appBarHeight,
              width: width,
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: navigationItems
                      .map((navItem) => navItem.screen)
                      .toList())),
        ),
      )),
    );
  }
}
