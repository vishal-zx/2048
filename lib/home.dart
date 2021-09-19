import 'package:flutter/material.dart';
import 'package:game2048/board.dart';
import 'package:game2048/sqaure.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'game.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<List<int>> board = [];
  List<List<int>> newBoard = [];
  int score=0;
  bool gameOver = false;
  bool gameWon = false;
  late SharedPreferences sp;

  List<Widget> getBoard(double width, double height){
    List<Widget> boards = [];
    for(int i=0;i<4;i++){
      for(int j=0;j<4;j++){
        int num = board[i][j];
        String number;
        int color;
        if(num == 0){
          color = 0xFFbfafa0;
          number = "";
        }
        else if(num == 2 || num==4){
          color = 0xFFeee4da;
          number = "$num";
        }
        else if(num == 8 || num==64 || num==256){
          color = 0xFFf5b27e;
          number = "$num";
        }
        else if(num == 16 || num==32 || num==1024){
          color = 0xFFecc402;
          number = "$num";
        }
        else if(num == 128 || num==512){
          color = 0xFFf77b5f;
          number = "$num";
        }
        else {
          color = 0xFF60d992;
          number = "$num";
        }
        double size = 0;
        String n = "$number";
        switch(n.length){
          case 1:
          case 2:
            size = 40.0;
            break;
          case 3:
            size = 30.0;
            break;
          case 4:
            size = 20.0;
            break;
        }
        boards.add(Square(number, width, height, color, size));
      }
    }
    return boards;
  }

  void gestures(int dir){
    // 0-up, 1-down, 2-left, 3-right
    bool flipped = false;
    bool played = true;
    bool rotated = false;
    if(dir == 0){
      setState(() {
        board = transposeGrid(board);
        board = flipGrid(board);
        rotated = true;
        flipped = true;
      });
    } 
    else if(dir == 1){  
      setState(() {
        board = transposeGrid(board);
        rotated = true;
      });
    } 
    else if (dir == 2) {
    } 
    else if (dir == 3) {
      setState(() {
        board = flipGrid(board);
        flipped = true;
      });
    } else {
      played = false;
    }

    if (played) {
      print('playing');
      List<List<int>> past = copyGrid(board);
      print('past $past');
      for (int i = 0; i < 4; i++) {
        setState(() {
          List result = operate(board[i], score, sp);
          score = result[0];
          print('score in set state $score');
          board[i] = result[1];
        });
      }
      // setState(() {
      //   board = addNumber(board, newBoard);
      // });
      bool changed = compare(past, board);
      print('changed $changed');
      if (flipped) {
        setState(() {
          board = flipGrid(board);
        });
      }

      if (rotated) {
        setState(() {
          board = transposeGrid(board);
        });
      }

      if (changed) {
        setState(() {
          board = addNumber(board, newBoard);
          print('is changed');
        });
      } else {
        print('not changed');
      }

      bool gameover = isGameOver(board);
      if (gameover) {
        print('game over');
        setState(() {
          gameOver = true;
        });
      }

      bool gamewon = isGameWon(board);
      if (gamewon) {
        print("GAME WON");
        setState(() {
          gameWon=true;          
        });
      }
      print(board);
      print(score);
    }
  }

  @override
  void initState(){
    board = blankGrid();
    newBoard = blankGrid();
    addNumber(board, newBoard);
    addNumber(board, newBoard);
    super.initState();
  }

  Future<String> getHighestScore() async{
    sp = await SharedPreferences.getInstance();
    int? sc = 0;
    sc = sp.getInt('highScore');
    return sc.toString();
  }

  @override
  Widget build(BuildContext context) {   
    double wd = MediaQuery.of(context).size.width;
    double gWidth = (wd-80)/4;
    double gHeight = gWidth;
    double ht = 30 + (gHeight*4)+10;
    return Scaffold(
      appBar: AppBar(         
        centerTitle: true,    
        title: Text(
          "2048",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFa2917d),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xFFa2917d),
                  ),
                  height: 82.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                        child: Text(
                          'Score',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          '$score',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ),
              ),
              Container(
                height: ht,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: GestureDetector(
                        child: GridView.count(
                          primary: false,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          crossAxisCount: 4,
                          children: getBoard(gWidth, gHeight),
                        ),
                        onVerticalDragEnd: (DragEndDetails details) {
                          //primaryVelocity -ve up +ve down
                          if (details.primaryVelocity! < 0) {
                            gestures(0);
                          } else if (details.primaryVelocity! > 0) {
                            gestures(1);
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          //-ve right, +ve left
                          if (details.primaryVelocity! > 0) {
                            gestures(2);
                          } else if (details.primaryVelocity! < 0) {
                            gestures(3);
                          }
                        },
                      ),
                    ),
                    gameOver
                        ? Container(
                            height: ht,
                            color: Color(0x80FFFFFF),
                            child: Center(
                              child: Text(
                                'Game over!',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFa2917d)
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    gameWon
                        ? Container(
                            height: ht,
                            color: Color(0x80FFFFFF),
                            child: Center(
                              child: Text(
                                'You Won!',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFa2917d)
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),    
                  ],
                ),
                color: Color(0xFFa2917d),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xFFa2917d),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: IconButton(
                          iconSize: 35.0,
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              board = blankGrid();
                              newBoard = blankGrid();
                              board = addNumber(board, newBoard);
                              board = addNumber(board, newBoard);
                              score = 0;
                              gameOver=false;
                              gameWon=false;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xFFa2917d),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'High Score',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                            FutureBuilder<String>(
                              future: getHighestScore(),
                              builder: (ctx, snapshot) {
                                if (snapshot.hasData && snapshot.data!="null") {
                                  return Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ), 
    );
  }
}
