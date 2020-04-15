import 'package:flutter/material.dart';
import 'package:helper/samples/dragable.dart';
import 'package:helper/samples/forms.dart';
import 'package:helper/samples/list-icon.dart';
import 'package:helper/samples/options.dart';
import 'package:helper/samples/short-widget.dart';
import 'package:helper/services/helper.dart';

import 'samples/date-picker.dart';
import 'samples/snake-game.dart';
import 'service2/sample.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color _black = Colors.black54;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Helper',
      theme: ThemeData(   
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
              color: _black
            )
          ),
          iconTheme: IconThemeData(
            color: _black
          )
        ),
        iconTheme: IconThemeData(
          color: _black
        ),
        buttonTheme: ButtonThemeData(minWidth: 0),
        textTheme: TextTheme(
          body1: TextStyle(fontFamily: 'sans', fontSize: 15)
        )
        
     ),
    home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void samples(menu){
    switch (menu) {
      case 'forms': modal(context, child: Forms(ctx: context)); break;
      case 'datepicker': modal(context, child: DatePicker()); break;
      case 'options': modal(context, child: Options()); break;
      case 'shortwidget': modal(context, child: ShortWidget()); break;
      case 'icons': modal(context, child: ListIcons()); break;
      case 'dragable': modal(context, child: Dragable()); break;
      case 'snakegame': modal(context, child: SnakeGame()); break;
      case 'service2': modal(context, child: Sample()); break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> menus = ['Forms','Date Picker','Options','Short Widget','Icons','Dragable','Snake Game','Service 2'];

    return Scaffold(
      appBar: Wi.appBar(context, title: 'Helper', back: false),
      body: GridView.builder(
        padding: EdgeInsets.all(15),
        itemCount: menus.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, childAspectRatio: 3),
        itemBuilder: (BuildContext context, int i){
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Inkl(
              onTap: (){
                samples(menus[i].toLowerCase().replaceAll(new RegExp(r"\s+\b|\b\s"), ''));
              },
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Center(
                  child: text(menus[i])
                )
              ),
            ),
          );
        }
      )
      
      // SingleChildScrollView(
      //   padding: EdgeInsets.all(15),
      //   child: Column(
      //     children: [

      //       Inkl(
      //         onTap: (){ },
      //         color: Colors.white,
      //         splash: Colors.blue[100],
      //         child: Container(
      //           width: mquery(context),
      //           child: text('Innk'),
      //         )
      //       )

      //     ]
      //   ),
      // ),
    );
  }
}