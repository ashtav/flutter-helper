import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';
import 'package:flutter/services.dart';

class HOptions extends StatefulWidget {
  final List<String> options;

  HOptions({this.options});

  @override
  _HOptionsState createState() => _HOptionsState();
}

class _HOptionsState extends State<HOptions> {
  @override
  Widget build(BuildContext context) {
    return widget.options == null || widget.options.length == 0 ? SizedBox.shrink() : ShowUp(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Container(
            margin: EdgeInsets.all(10),
            child: Material(
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white
                  ),
                  // margin: EdgeInsets.all(10),
                  width: mquery(context),
                  child: Column(
                    children: List.generate(widget.options.length, (int i){
                      return Inkl(
                        onTap: (){
                          Navigator.pop(context, {'option': widget.options[i]});
                        },
                        child: Container(
                          width: mquery(context),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: i == 0 ? Border() : Border(
                              top: BorderSide(color: Colors.black12)
                            )
                          ),
                          child: text(Fn.ucwords(widget.options[i]), align: TextAlign.center)
                        ),
                      );
                    })
                  )
                ),
              ),
            ),
          ),

          Container(
            width: mquery(context),
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Inkl(
                padding: EdgeInsets.all(15),
                onTap: (){ Navigator.pop(context); },
                child: Material(
                  color: Colors.transparent,
                  child: text('Batal', align: TextAlign.center)
                ),
              ),
            )
            
            
          ),

        ]
      ),
    );
  }
}

class HConfirmation extends StatefulWidget {
  final String url, message;
  HConfirmation({this.url, this.message: 'Yakin ingin menghapus data ini?'});

  @override
  _HConfirmationState createState() => _HConfirmationState();
}

class _HConfirmationState extends State<HConfirmation> {

  @override
  Widget build(BuildContext context) {
    return ShowUp(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              margin: EdgeInsets.all(10),
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                    width: mquery(context),
                    child: Column(
                      children: [

                        Container(
                          margin: EdgeInsets.all(15),
                          child: text(widget.message),
                        ),

                        Row(
                          children: List.generate(2, (int i){
                            var labels = ['batal', 'iya'];

                            return Inkl(
                              onTap: (){
                                Navigator.pop(context, i);
                              },
                              color: i == 0 ? Colors.white : Clr.black(opacity: .05),
                              child: Container(
                                width: mquery(context) / 2 - 10,
                                padding: EdgeInsets.all(15),
                                child: text(Fn.ucwords(labels[i]), align: TextAlign.center)
                              ),
                            );
                          })
                        )

                      ]
                    )
                    
                  ),
                ),
              ),
            ),

          ]
      ),
    );
  }
}

class HNumberInput extends StatefulWidget {
  final String label, init;
  final TextEditingController controller;
  final FocusNode node;
  final TextInputAction inputAction;
  final Function onSubmit, onChange;

  HNumberInput({this.label, this.init, this.controller, this.node, this.inputAction, this.onSubmit, this.onChange});

  @override
  _HNumberInputState createState() => _HNumberInputState();
}

class _HNumberInputState extends State<HNumberInput> {

  void _count(i){
    var ctrl = widget.controller.text == '' ? 0 : int.parse(widget.controller.text);

    switch (i) {
      case 0: // decrease
        if(ctrl > 0){
          widget.controller.text = (ctrl - 1).toString();
        } break;
      default: // increase
        if(ctrl < 99999999999){
          widget.controller.text = (ctrl + 1).toString();
        } break;
    }
  }

  void _onChange(s){
    if(s == ''){ widget.controller.text = '0'; }

    var str = s.substring(0, 1);
    if(s == '0' || str == '0'){
      widget.controller.text = s.substring(1);
    }
  }

  @override
  void initState() {
    super.initState();

    widget.controller.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.label == null ? SizedBox.shrink() : 
        Container(
          margin: EdgeInsets.only(bottom: 7),
          child: text(widget.label, bold: true)
        ),

        Container(
          margin: EdgeInsets.only(bottom: 25),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white
                  ),
                  child: TextField(
                  controller: widget.controller,
                  focusNode: widget.node,
                  // maxLines: lines,
                  keyboardType: TextInputType.datetime,
                  textInputAction: widget.inputAction,
                  onSubmitted: widget.onSubmit,
                  onChanged: _onChange,
                  decoration: new InputDecoration(
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                    isDense: true,
                    hintStyle: TextStyle(fontFamily: 'sans'),
                    contentPadding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10)
                  ),
                  style: TextStyle(fontFamily: 'sans'),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(11),
                  ],
                ),
                ),

                Positioned(
                  right: 0,
                  child: Row(
                    children: List.generate(2, (int i){
                      var icons = [Icons.remove, Icons.add];
                      return Inkl(
                        onTap: (){ _count(i); },
                        padding: EdgeInsets.only(top: 7, bottom: 7, left: 10, right: 10),
                        child: Icon(icons[i]),
                      );
                    })
                  ),
                )
              ]
            ),
          ),
        )

        
      ],
    );
  }
}

class HDropdown extends StatefulWidget {
  final String label;
  final List options, values;
  final TextEditingController controller;

  HDropdown({this.label, @required this.options, this.values, @required this.controller});

  @override
  _HDropdownState createState() => _HDropdownState();
}

class _HDropdownState extends State<HDropdown> {
  GlobalKey _key = GlobalKey();
  ScrollController _scrollController = ScrollController();

  _scrollToTop() {
    Timer(Duration(milliseconds: 200), (){ 
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    });
  }

  void _showOptions(){
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero),
          size = renderBox.size;

    showDialog(
      context: context,
      builder: (BuildContext context){
        return GestureDetector(
          onTap: (){ Navigator.pop(context); },
          child: ScrollConfiguration(
            behavior: PreventScrollGlow(),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [

                  Container(
                    margin: EdgeInsets.only(top: position.dy - 24),
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(4)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(widget.options.length, (int i){
                              return Inkl(
                                onTap: (){
                                  Navigator.pop(context, widget.options[i]);
                                },
                                child: Container(
                                  width: mquery(context),
                                  padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                  child: text(widget.options[i]),
                                ),
                              );
                            })
                          ),
                        ),
                      ),
                    ),
                  )

                ]
              ),
            ),
          ),
        );
      }
    ).then((res){
      if(res != null){
        setState(() => widget.controller.text = res );
      }
    });

    _scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label == null ? SizedBox.shrink() : 
          Container(
            margin: EdgeInsets.only(bottom: 7),
            child: text(widget.label, bold: true),
          ),

          Stack(
            children: [
              Inkl(
                onTap: (){
                  _showOptions();
                },
                color: Colors.white,
                child: Container(
                  key: _key,
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                  width: mquery(context),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: text(widget.controller.text),
                ),
              ),

              Positioned(
                right: 10, top: 7,
                child: IgnorePointer(child: Icon(Icons.expand_more)),
              ),



            ]
          )

          
        ]
      ),
    );
  }
}