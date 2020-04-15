import 'package:flutter/material.dart';
import 'package:helper/service2/helper.dart';

class Sample extends StatefulWidget {
  @override
  _SampleState createState() => _SampleState();
}

class _SampleState extends State<Sample> {

  var data = false;
  var cont = TextEditingController();

  bool isSubmit = false;

  @override
  Widget build(BuildContext context) {
    return PreventSwipe(
      child: Scaffold(
        appBar: Wi.appBar(context, title: 'lorem ipsum', autoLeading: true),

        body: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              FormControl.radio(label: 'Radio', values: ['lorem','ipsum','dolor','set','amet','consectetur'], checked: 'ipsum', onChange: (c){ print(c);  }),
              FormControl.checkbox(label: 'Checkbox', values: ['lorem','ipsum','dolor','consectetur','adipliscing','amet'], checked: ['lorem'], onChange: (c){ print(c);  }),

              FormControl.dropdown(label: 'Dropdown', controller: cont, options: ['lorem','ipdum','dolor','set','amet','cons','final','widget','object','laravel','flutter','android']),
              FormControl.select(context, label: 'Select', controller: cont, icon: Icon(Icons.expand_more), onTap: (){
                modal(context, child: Container());
              }),

              FormControl.button(textButton: 'Button', isSubmit: isSubmit, onTap: (){
                setState(() {
                  isSubmit = true;
                });
              }),

              GestureDetector(
                onTap: (){
                  Wi.toast(cont.text.toString());

                  // Wi.options(context, options: ['Edit','Delete'], then: (res){
                  //   print(res);
                  // });


                },
                child: Container(
                  width: Mquery.width(context),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38)
                  ),
                  child: text('text'),
                ),
              ),


            ]
          ),
        ),
      ),
    );
  }
}