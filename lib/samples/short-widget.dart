import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';

class ShortWidget extends StatefulWidget {
  @override
  _ShortWidgetState createState() => _ShortWidgetState();
}

class _ShortWidgetState extends State<ShortWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wi.appBar(context, title: 'Short Widget'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [

            Wi.itext(icon: Icons.phone, child: text('with icon data')),
            Wi.itext(icon: Wi.spiner(), child: text('icon text spinner')),
            
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Wi.itext(icon: Icon(Icons.insert_chart), child: text('widget and text')),
            ),

            HList(labels: ['Lorem','Ipsum','Dolor','Amet'], values: ['0','1','2','3'],)
            


          ]
        ),
      ),
    );
  }
}