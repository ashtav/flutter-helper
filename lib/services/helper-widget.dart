import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper.dart';

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
                          Navigator.pop(context, i);
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
  HConfirmation({this.url, this.message});

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
              margin: EdgeInsets.all(15),
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
                          child: html(widget.message == null ? '' : widget.message),
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
                                width: mquery(context) / 2 - 15,
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

class HSelect extends StatefulWidget {
  final ctx;
  final String label;
  final Function onChange;
  final bool enabled;
  final Widget options;
  final TextEditingController controller;

  HSelect(this.ctx, {this.label, @required this.options, @required this.controller, this.enabled: true, this.onChange});

  @override
  _HSelectState createState() => _HSelectState();
}

class _HSelectState extends State<HSelect> {

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
                onTap: !widget.enabled ? null : (){
                  modal(widget.ctx, child: widget.options, onClose: (res){
                    if(res != null){
                      widget.onChange(res);
                    }
                  });
                },
                color: !widget.enabled ? Clr.black(opacity: .07) : Colors.white,
                child: Container(
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(widget.options.length, (int i){
                                return Inkl(
                                  onTap: (){
                                    Navigator.pop(context, widget.options[i]);
                                  },
                                  child: Container(
                                    width: mquery(context),
                                    color: widget.options[i] != widget.controller.text ? Colors.white : Clr.black05(),
                                    padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        text(widget.options[i]),
                                        
                                        widget.options[i] != widget.controller.text ? SizedBox.shrink() :
                                        Icon(Icons.check, color: Colors.green, size: 20,)
                                      ]
                                    )
                                  ),
                                );
                              })
                            ),
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


class HRadioButton extends StatefulWidget {
  final String label; var checked;
  final List values;
  final Function onChange;
  final double mb, mt;

  HRadioButton({this.label, @required this.values, @required this.checked, this.onChange, this.mb, this.mt});

  @override
  _HRadioButtonState createState() => _HRadioButtonState();
}

class _HRadioButtonState extends State<HRadioButton> {

  void _onChecked(i){ 
    setState(() {
      widget.checked = widget.values[i];
    });

    if(widget.onChange != null){
      widget.onChange(widget.checked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.mb, top: widget.mt),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.label == null ? SizedBox.shrink() : 
          Container(
            margin: EdgeInsets.only(bottom: 7),
            child: text(widget.label, bold: true),
          ),

          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
            children: List.generate(widget.values.length, (int i){
              var checked = widget.values[i].toLowerCase() == widget.checked.toLowerCase();

              return Container(
                margin: EdgeInsets.only(right: 10),
                child: Inkl(
                  onTap: (){ _onChecked(i); },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 20, width: 20,
                        // padding: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: checked ? Border() : Border.all(color: Colors.black38),
                          color: checked ? Colors.blue : Colors.white,
                        ),
                        child: checked ? Icon(Icons.fiber_manual_record, color: Colors.white, size: 20) : SizedBox.shrink(),
                      ), text(widget.values[i])
                    ]
                  ),
                )
                
              );
            }),
          ))
        ],
      ),
    );
  }
}

class HCheckBox extends StatefulWidget {
  final String label;
  final List values, checked;
  final Function onChange;
  final double marginY;
  final bool enabled;

  HCheckBox({this.label, @required this.values, @required this.checked, this.enabled: true, this.onChange, this.marginY});

  @override
  _HCheckBoxState createState() => _HCheckBoxState();
}

class _HCheckBoxState extends State<HCheckBox> {

  void _onChecked(i){
    var v = widget.values[i];

    setState(() {
      if(widget.checked.indexOf(v) > -1){
        widget.checked.remove(v);
      }else{
        widget.checked.add(v);
      }
    });

    widget.onChange(widget.checked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.marginY == null ? 25 : widget.marginY),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.label == null ? SizedBox.shrink() : 
          Container(
            margin: EdgeInsets.only(bottom: 7),
            child: text(widget.label, bold: true),
          ),

          SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(
            children: List.generate(widget.values.length, (int i){
              var checkeds = widget.checked.indexOf(widget.values[i]);
              return Container(
                margin: EdgeInsets.only(right: 10),
                child: Inkl(
                  onTap: !widget.enabled ? null : (){ _onChecked(i); },
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 20, width: 20,
                        // padding: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          border: checkeds > -1 ? Border() : Border.all(color: Colors.black38),
                          color: checkeds > -1 ? Colors.blue : Colors.white,
                        ),
                        child: checkeds > -1 ? Icon(Icons.check, color: Colors.white, size: 20) : SizedBox.shrink(),
                      ), text(widget.values[i])
                    ]
                  ),
                )
                
              );
            }),
          ))
        ],
      ),
    );
  }
}


class HOptionBox extends StatefulWidget {
  final String label; var checked;
  final List values;
  final Function onChange;

  HOptionBox({this.label, @required this.values, @required this.checked, this.onChange});

  @override
  _HOptionBoxState createState() => _HOptionBoxState();
}

class _HOptionBoxState extends State<HOptionBox> {

  void _onChecked(i){ 
    setState(() {
      widget.checked = widget.values[i];
    });

    if(widget.onChange != null){
      widget.onChange(widget.checked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.label == null ? SizedBox.shrink() : 
          Container(
            margin: EdgeInsets.only(bottom: 7),
            child: text(widget.label, bold: true),
          ),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(4)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Row(
                children: List.generate(widget.values.length, (int i){
                  return Container(
                    width: mquery(context) / widget.values.length - 8,
                    decoration: BoxDecoration(
                      border: i == 0 ? Border() : Border(
                        left: BorderSide(color: Colors.black12)
                      )
                    ),
                    child: Inkl(
                      onTap: (){ _onChecked(i); },
                      padding: EdgeInsets.all(11),
                      color: widget.values[i] == widget.checked ? Clr.black05() : Colors.white,
                      child: Container(
                        child: text(widget.values[i], align: TextAlign.center, bold: widget.values[i] == widget.checked),
                      ),
                    ),
                  );
                })
              )
            ),
          )

        ],
      ),
    );
  }
}

class HToggle extends StatefulWidget {
  final Function onChange;
  bool value, enabled;
  String label;

  HToggle({this.onChange, this.value, this.enabled, this.label});

  @override
  _HToggleState createState() => _HToggleState();
}

class _HToggleState extends State<HToggle> {

  @override
  Widget build(BuildContext context) {
    return Inkl(
      radius: BorderRadius.circular(50),
      padding: EdgeInsets.all(5),
      onTap: !widget.enabled ? null : (){
        setState(() => widget.value = !widget.value );
        widget.onChange(widget.value);
      },
      child: Row(
        children: <Widget>[

          Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 5, top: 5),
                width: 37, height: 14,
                decoration: BoxDecoration(
                  color: widget.value ? Colors.blue[200] : Colors.black12,
                  borderRadius: BorderRadius.circular(50)
                ),
              ),

              AnimatedPositioned(
                top: 1, left: widget.value ? 15 : 0,
                duration: Duration(milliseconds: 100),
                child: Container(
                  height: 22, width: 22,
                  decoration: BoxDecoration(
                    color: widget.value ? Colors.blue : Colors.grey[400],
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: widget.value ? Colors.blue[100] : Colors.black38,
                        blurRadius: 1.0, // has the effect of softening the shadow
                        spreadRadius: .5, // has the effect of extending the shadow
                        offset: Offset(1, .5),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),

          widget.label == null ? SizedBox.shrink() : text(widget.label)

        ],
      )
      
    );
  }
}

class ListExpanded extends StatefulWidget {
  bool expand;
  final Widget title;
  final List list;
  final Function onExpand, onListTap;

  ListExpanded({this.title, this.list, this.expand: false, this.onExpand, this.onListTap});

  @override
  _ListExpandedState createState() => _ListExpandedState();
}

class _ListExpandedState extends State<ListExpanded> {
  
  @override
  Widget build(BuildContext context) {
  var _h = (47.5 * (widget.list.length + 1)).toDouble();

    return Container(
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: widget.expand ? _h : 0),

          AnimatedPositioned(
            top: widget.expand ? 49 : -_h,
            duration: Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(
                color: Clr.black05(),
                border: Border(
                  top: BorderSide(color: Colors.black12),
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(widget.list.length, (int i){
                  return Inkl(
                    onTap: (){ if(widget.onListTap != null) widget.onListTap(i); },
                    child: Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                      width: mquery(context),
                      child: text(widget.list[i]),
                    )
                  );
                }),
              ),
            ),
          ),

          Container(
            child: Inkl(
              onTap: (){ 
                setState(() => widget.expand = !widget.expand );
                if(widget.onExpand != null) widget.onExpand(widget.expand);
              },
              color: Colors.white,
              child: Container(
                // decoration: BoxDecoration(
                //   border: Border(
                //     bottom: BorderSide(color: Colors.black12),
                //     // top: BorderSide(color: !widget.expand ? Colors.black12 : Colors.transparent),
                //   )
                // ),
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.title,

                    RotationTransition(
                      turns: new AlwaysStoppedAnimation(widget.expand ? .25 : 0),
                      child: Icon(Icons.chevron_right, size: 19, color: Colors.black45)
                    )
                    
                  ],
                )
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}