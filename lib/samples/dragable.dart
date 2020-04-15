import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';

class Dragable extends StatefulWidget {
  @override
  _DragableState createState() => _DragableState();
}

class _DragableState extends State<Dragable> {

  double size = 100, bv = 0, bh = 0, tapPosY = 0, tapPosX = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

            Container(
              height: double.infinity,
            ),

            AnimatedPositioned(
              top: bv, left: bh,
              duration: Duration(milliseconds: 100),
              child: GestureDetector(
                onVerticalDragUpdate: (d){
                  setState(() {
                    bv = d.globalPosition.dy - tapPosY;
                  });
                },

                onHorizontalDragUpdate: (d){
                  setState(() {
                    bh = d.globalPosition.dx - tapPosX;
                  });
                },

                onHorizontalDragEnd: (d){
                  var maxWidth = mquery(context) - size; // width - ukuran box
                  setState(() {
                    if(bh < 0){
                      bh = 0;
                    }else if(bh > maxWidth){
                      bh = maxWidth;
                    }
                  });
                },

                onVerticalDragEnd: (d){
                  var maxHeight = mquery(context, attr: 'height') - size; // height - ukuran box
                  setState(() {
                    if(bv < 0){
                      bv = 0;
                    }else if(bv > maxHeight){
                      bv = maxHeight;
                    }
                  });
                },

                onDoubleTap: (){
                  setState(() {
                    size = size + 10;
                  });
                },

                onLongPress: (){
                  setState(() {
                    size = size - 10;
                  });
                },

                onTapDown: (d){
                  tapPosY = d.localPosition.dy;
                  tapPosX = d.localPosition.dx;
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  height: size, width: size,
                  color: Colors.blueGrey,
                ),
              ),
            )



        ],
      ),
    );
  }
}