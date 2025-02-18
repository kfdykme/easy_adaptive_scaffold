import 'dart:io';
import 'dart:math';

import 'package:easy_adaptive_scaffold/easy_adaptive_layout.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(HomeApp());
}
class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeAppState();
  }
}

class HomeAppState extends State<HomeApp> { 
 
  
  List<EasyAdaptiveLayoutNavItemConfig> initConfigs() {
    return List.filled(10,1).map((i){
      String title = (Random().nextInt(10000) + 1000).toRadixString(16);
      return EasyAdaptiveLayoutNavItemConfig(title: title, icon:  const Icon(Icons.abc), builder: (context) {
        return Text(title);
      },);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return EasyAdaptiveLayout(
      navConfigs: initConfigs(),
    );
  }
}
