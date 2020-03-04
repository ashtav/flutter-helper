import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';

class Options extends StatefulWidget {
  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {

  void _execute() async {
    Fn.toast('Delete selected');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Wi.appBar(context, title: 'Options'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [

            Inkl(
              onTap: (){
                Wi.options(context, options: ['edit','hapus'], then: (res){
                  if(res != null){
                    switch (res['option']) {
                      case 'edit': Fn.toast('Edit selected'); break;
                      default: Wi.confirm(context, then: (res){
                        if(res != null && res == 1){
                          _execute();
                        }
                      }); break;
                    }
                  }
                });
              },
              color: Clr.black(opacity: .05),
              radius: BorderRadius.circular(5),
              padding: EdgeInsets.all(10),
              child: Container(
                width: mquery(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text('More Options'),
                    Icon(Icons.more_vert)
                  ]
                )
              )
            )
            
          ]
        ),
      ),
    );
  }
}