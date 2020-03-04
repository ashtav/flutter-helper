import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';

class Forms extends StatefulWidget {
  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  var number = TextEditingController();
  var dropdown = TextEditingController(text: 'lorem');

  var rbGroup = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wi.appBar(context, title: 'Forms'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Fc.input(
              label: 'Border Text Input', hint: 'Input text'
            ),

            Fc.number(
              controller: number,
              label: 'Number Input'
            ),

            Fc.radio(label: 'Radio Button', values: ['lorem','ipsum','dolor','sit','amet'], group: rbGroup, onChange: (res){
              setState(() {
                rbGroup = res['index'];
              });
              print(res);
            }),

            Fc.dropdown(label: 'Dropdown', controller: dropdown, options: ['lorem','ipsum','dolor','lorem']),
            Fc.input(
              label: 'Border Text Input', hint: 'Input text'
            ),
            Fc.dropdown(label: 'Dropdown', controller: dropdown, options: ['lorem','ipsum','dolor','lorem','ipsum','dolor','sit','amet']),


          ]
        ),
      ),
    );
  }
}