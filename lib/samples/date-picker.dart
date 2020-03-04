import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';

class DatePicker extends StatefulWidget {
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime date1 = DateTime.now();
  TextEditingController date2 = TextEditingController();
  TextEditingController date3 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wi.appBar(context, title: 'Date Picker', actions: [
        IconButton(
          onPressed: (){
            Wi.datePicker(context, init: date1).then((res){
              setState(() {
                if(res != null)
                date1 = DateTime.parse(res);
              });
            });
          },
          icon: Icon(Icons.date_range,)
        )
      ]),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text('Date From Icon : \n'+date1.toString()),

            FormControl.select(
              label: 'Select Date',
              controller: date2,
              onTap: (){
                Wi.datePicker(context, init: date1).then((res){
                  setState(() {
                    if(res != null){
                      date1 = DateTime.parse(res);
                      date2.text = res;
                    }
                  });
                });
              }
            ),

            FormControl.select(
              label: 'Select Date Range',
              controller: date3,
              onTap: (){
                Wi.dateRangePicker(context).then((res){
                  setState(() {
                    if(res != null){
                      List<String> date = [];
                      res.forEach((d) => date.add(d.toString().split(' ')[0]));
                      setState(() {
                        date3.text = date.join(' - ');
                      });
                    }
                  });
                });
              }
            )
          ]
        ),
      ),
    );
  }
}