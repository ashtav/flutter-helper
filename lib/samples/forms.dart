import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';

class Forms extends StatefulWidget {
  final ctx;
  Forms({this.ctx});

  @override
  _FormsState createState() => _FormsState();
}

class _FormsState extends State<Forms> {
  var number = TextEditingController();
  var dropdown = TextEditingController(text: 'lorem');
  var select = TextEditingController(text: 'option 1');

  var radio = 'apple';
  var checkbox = ['adisp'];

  RangeValues _values = RangeValues(0.0, 0.7);
  double _slider = 20;

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

            Fc.select(widget.ctx, label: 'Select', controller: select, options: SelectOptions(), onChange: (res){
              setState(() {
                select.text = res['value'];
              });
            }),

            Fc.radio(label: 'Radio Button', values: ['apple','banana','durian','watermelon','berry'], checked: radio, onChange: (res){
              print(res);
            }),

            Fc.checkbox(label: 'Checkbox', values: ['consectetur','adisp','spectrum','accent','box'], checked: checkbox, onChange: (res){
              print(res);
            }),

            Fc.dropdown(label: 'Dropdown', controller: dropdown, options: ['lorem','ipsum','dolor','lorem']),
            
            Fc.button(
              onTap: (){},
              width: mquery(context),
              child: text('Button', color: Colors.white, align: TextAlign.center)
            ),

            Fc.dropdown(label: 'Dropdown', controller: dropdown, options: ['lorem','ipsum','dolor','lorem','ipsum','dolor','sit','amet']),

            RangeSlider(
              values: _values,
              labels: RangeLabels(_values.start.toString(), _values.end.toString()),
              divisions: 10,
              onChanged: (RangeValues values) {
                setState(() {
                  _values = values;
                  print(values);
                });
              },
            ),

            Slider(
              value: _slider,
              min: 0.0,
              max: 100.0,
              divisions: 5,
              label: _slider.toString(),
              onChanged: (double value) { print(value);
                setState(() {
                  _slider = value;
                });
              },
            ),
                

          ]
        ),
      ),
    );
  }
}

class SelectOptions extends StatefulWidget {
  @override
  _SelectOptionsState createState() => _SelectOptionsState();
}

class _SelectOptionsState extends State<SelectOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wi.appBar(context, title: 'Select Item'),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, i){
          var val = 'option '+i.toString();

          return Inkl(
            onTap: (){
              Navigator.pop(context, {'value': val});
            },
            color: i % 2 == 0 ? Clr.black(opacity: .05) : Colors.white,
            child: Container(
              padding: EdgeInsets.all(15),
              child: text(val),
            ),
          );
        },
      ),
    );
  }
}