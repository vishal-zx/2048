import 'package:flutter/material.dart';

class Square extends StatefulWidget {

  String number;
  double width,height;
  int color;
  double size;
  Square(this.number,this.width,this.height,this.color,this.size);

  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _SquareState();
    }
}

class _SquareState extends State<Square> {
  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Container(
        child: Center(
          child: Text(widget.number,style: TextStyle(fontSize:widget.size,fontWeight: FontWeight.bold,color: Color(0xFF766c62)),),
        ),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: Color(widget.color),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      );
    }
}