import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:helper/services/helper.dart';

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {

  double bs = 0, px = 0, py = 0;
  Timer timer;

  // ukuran maksimal canvas
  double maxw = 0, maxh = 0;

  // control
  String moveTo;

  initGame(){
    timer = Timer.periodic(Duration(seconds: 1), (t){
      var width = MediaQuery.of(context).size.width, boxSize = width / 17;

      setState((){
        moveTo = 'top';
        bs = boxSize;
        maxw = width; maxh = boxSize * 19;

        var randX = Random().nextInt(width.toInt()).toDouble(),
            randY = Random().nextInt((boxSize * 19).toInt()).toDouble();

        px = randX >= maxw ? maxw - boxSize : randX;
        py = randY >= maxh ? maxh - boxSize : randY;
      });

      timer.cancel();
    });
  }

  _playGame(){

    timer = Timer.periodic(Duration(milliseconds: 500), (t){
      setState(() {
        
        switch (moveTo) {
          case 'top': setState(() => py += bs ); break;
          case 'right': setState(() => px += bs ); break;
          case 'bottom': setState(() => py -= bs ); break;
          case 'left': setState(() => px -= bs ); break;
          default:
        }
      });

      if(py >= maxh){
        timer.cancel();
        py = maxh - bs;
        Fn.toast('Game Over!');
      }

      print(py);
    });
  }

  _stopGame(){
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bs == 0 ? Colors.white : Colors.blueGrey,
      appBar: Wi.appBar(context, title: '', actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: (){
            timer.cancel();
            setState(() {
              py = 0; px = 22;
            });
          },
        ),

        IconButton(
          icon: Icon(Icons.play_circle_outline),
          onPressed: (){
            _playGame();
          },
        ),

        IconButton(
          icon: Icon(Icons.stop),
          onPressed: (){
            _stopGame();
          },
        ),
      ]),
      body: bs == 0 ? Wi.spiner(size: 50) : 
      Column(
        children: [
          
      Stack(
        children: [
          Container(
            height: bs * 19,
            width: mquery(context),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12
                )
              )
              // border: Border.all(color: bs == 0 ? Colors.transparent : Colors.blueGrey)
            ),
          ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 100),
            left: px, bottom: py,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: bs, height: bs,
              color: Colors.blueGrey,
            ),
          ),

        ]
      ),

          Container(
            color: Colors.white,
            height: 156, width: mquery(context),
            child: Stack(
              children: [
                Container(),
                Positioned(
                  left: mquery(context) / 2 - 22,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (int i){
                      var icons = [Icons.arrow_upward,Icons.arrow_downward];
                      return Container(
                        margin: EdgeInsets.only(top: i == 0 ? 10 : 43),
                        child: Inkl(
                          onTap: (){
                            setState(() => moveTo = i == 0 ? 'top' : 'bottom' );
                          },
                          radius: BorderRadius.circular(50),
                          padding: EdgeInsets.all(11),
                          color: Colors.black12,
                          child: Icon(icons[i]),
                        ),
                      );
                    })
                  ),
                ),

                Positioned(
                  // left: mquery(context) / 2 - 22,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(2, (int i){
                      var icons = [Icons.arrow_back,Icons.arrow_forward];
                      return Container(
                        margin: EdgeInsets.only(top: 53),
                        child: Inkl(
                          radius: BorderRadius.circular(50),
                          onTap: (){
                            setState(() => moveTo = i == 0 ? 'left' : 'right' );
                          },
                          padding: EdgeInsets.all(11),
                          color: Colors.black12,
                          child: Icon(icons[i]),
                        ),
                      );
                    })
                  ),
                )
              ]
            ),
          )

        ]
      )
    );
  }
}