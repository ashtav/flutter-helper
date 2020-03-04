import 'package:flutter/material.dart';
import 'package:helper/samples/forms.dart';
import 'package:helper/samples/options.dart';
import 'package:helper/services/helper.dart';

import 'samples/date-picker.dart';

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
      case 'forms': modal(context, child: Forms()); break;
      case 'datepicker': modal(context, child: DatePicker()); break;
      case 'options': modal(context, child: Options()); break;

      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> menus = ['Forms','Date Picker','Options'];

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