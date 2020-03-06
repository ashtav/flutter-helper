import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ListIcons extends StatefulWidget {
  @override
  _ListIconsState createState() => _ListIconsState();
}

class _ListIconsState extends State<ListIcons> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wi.appBar(context, title: 'Icons'),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // 1.0.0 version used
            Icon(AntDesign.stepforward),
            Icon(Ionicons.ios_search),
            Icon(FontAwesome.glass),
            Icon(MaterialIcons.ac_unit),
            Icon(FontAwesome5.address_book),
            Icon(FontAwesome5Solid.address_book),
            Icon(FontAwesome5Brands.$500px)

            // Previous versions of 1.0.0 are used
            // Icon(Ionicons.getIconData("ios-search"));
            // Icon(AntDesign.getIconData("stepforward"));
            // Icon(FontAwesome.getIconData("glass"));
            // Icon(MaterialIcons.getIconData("ac-unit"));
            // Icon(FontAwesome5.getIconData("address-book"));
            // Icon(FontAwesome5.getIconData("address-book",weight: IconWeight.Solid));
            // Icon(FontAwesome5.getIconData("500px", weight: IconWeight.Brand));


          ]
        ),
      ),
    );
  }
}