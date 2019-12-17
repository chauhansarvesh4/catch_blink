import 'dart:async';

import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'dart:math' as maths;
import 'package:vector_math/vector_math.dart' as vector;

class CircularGame extends StatefulWidget {
  @override
  _CircularGameState createState() => _CircularGameState();
}

class _CircularGameState extends State<CircularGame>
    with SingleTickerProviderStateMixin {
  Color player1Color, player2Color, circularIconColor;
  int k = 0, pKey, i, p1Score, p2Score, _speed, _pass;
  Timer timer;
  bool playerType; //false for player1 and true for player2

  @override
  void initState() {
    super.initState();
    player1Color = RandomColor().randomColor();
    player2Color = RandomColor().randomColor();
    circularIconColor = player1Color;
    pKey = maths.Random().nextInt(36) * 10;
    playerType = false;
    p1Score = 0;
    p2Score = 0;
    _speed = 80;
    _pass = 1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            player1Panel(size),
            Expanded(
                flex: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                        left: 0,
                        child: ClipPath(
                          clipper: MyCustomClipper("LEFT"),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 12),
                            width: 110,
                            height: 200,
                            color: Colors.white24,
                            child: Text(
                              "$_pass",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ),
                        )),
                    Container(
                      width: size.width,
                      child: Stack(
                          alignment: Alignment.center,
                          children: getCircularWidget()),
                    ),
                    IconButton(
                      onPressed: () {
                        if (timer == null)
                          timer = Timer.periodic(
                              new Duration(milliseconds: _speed), (timer) {
                            setState(() {
                              k = k + 10;
                            });
                          });
                      },
                      icon: Icon(
                        Icons.play_arrow,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                        right: 0,
                        child: ClipPath(
                          clipper: MyCustomClipper("RIGHT"),
                          child: Container(
                            width: 110,
                            height: 200,
                            color: Colors.white24,
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_speed < 140) {
                                        _speed = _speed + 10;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "${_speed}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (20 < _speed) {
                                        _speed = _speed - 10;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                )),
            player2Panel(size),
          ],
        ),
      ),
    );
  }

  Expanded player2Panel(Size size) {
    return Expanded(
      flex: 25,
      child: Container(
        width: size.width,
        child: Card(
          margin: const EdgeInsets.all(8),
          color: player2Color,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 70,
                child: SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.android,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Text(
                        "Player 2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(
                      "SCORE",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "$p2Score",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          playerType ? getPlayerChances() : getAllChances(),
                    )
                  ],
                )),
              ),
              Expanded(
                flex: 30,
                child: SizedBox.expand(
                  child: RaisedButton(
                    onPressed: () {
                      if(playerType)
                      if (pKey == k % 360) {
                        setState(() {
                          print(
                              "perfect2 vlaue of i $pKey and value of k ${k % 360}");
                          p2Score = p2Score + 10;
                          playerType = !playerType;
                          circularIconColor = player1Color;
                          pKey = maths.Random().nextInt(36) * 10;
                          k = 0;
                          timer.cancel();
                          timer = null;
                          _pass = _pass + 1;
                        });
                      } else {
                        print(
                            "miss player2 vlaue of i $pKey and value of k ${k % 360}");
                      }
                    },
                    color: Colors.white,
                    child: Icon(
                      Icons.close,
                      size: 36,
                      color: player2Color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded player1Panel(Size size) {
    return Expanded(
      flex: 25,
      child: Container(
        width: size.width,
        child: Card(
          margin: const EdgeInsets.all(8),
          color: player1Color,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 30,
                child: SizedBox.expand(
                  child: RaisedButton(
                    onPressed: () {
                      if(!playerType)
                      if (pKey == k % 360) {
                        setState(() {
                          print(
                              "perfect2 vlaue of i $pKey and value of k ${k % 360}");
                          playerType = !playerType;
                          p1Score = p1Score + 10;
                          circularIconColor = player2Color;
                          pKey = maths.Random().nextInt(36) * 10;
                          k = 0;
                          timer.cancel();
                          timer = null;
                          _pass = _pass + 1;
                        });
                      } else {
                        print(
                            "miss player1 vlaue of i $pKey and value of k ${k % 360}");
                      }
                    },
                    color: Colors.white,
                    child: Icon(
                      Icons.close,
                      size: 36,
                      color: player1Color,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 70,
                child: SizedBox(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Player 1",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: CircleAvatar(
                        child: Icon(
                          Icons.android,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "SCORE",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "$p1Score",
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          playerType ? getAllChances() : getPlayerChances(),
                    )
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getPlayerChances() {
    List<Widget> chanceList = [];
    int div = (k / 360).ceil();
    for (int c = 0; c <= 5; c++) {
      if (div <= c) {
        chanceList.add(Icon(
          Icons.track_changes,
          color: Colors.white,
          size: 16,
        ));
      } else {
        chanceList.add(Icon(
          Icons.close,
          color: Colors.white,
          size: 16,
        ));
      }
    }
    return chanceList;
  }

  List<Widget> getAllChances() {
    List<Widget> chanceList = [];
    int div = (k / 360).ceil();
    for (int c = 0; c <= 5; c++) {
      chanceList.add(Icon(
        Icons.track_changes,
        color: Colors.white,
        size: 16,
      ));
    }
    return chanceList;
  }

  List<Widget> getCircularWidget() {
    List<Widget> tempWidget = [];
    double rad;
    int tempK;

    if (k > 1800) {
      setState(() {
        pKey = maths.Random().nextInt(36) * 10;
        k = 0;
        timer.cancel();
        timer = null;
        playerType = !playerType;
        _pass = _pass + 1;
      });
    } else {
      tempK = k % 360;
    }
    for (i = 0; i <= 360; i = i + 10) {
      double d = i * 1.0;
      rad = vector.radians(d);
      tempWidget.add(Transform(
        transform: Matrix4.identity()
          ..translate(100 * maths.cos(rad), 100 * maths.sin(rad)),
        child: Icon(
          Icons.add_circle,
          color: playerType
              ? (tempK == i
                  ? Colors.black
                  : (pKey == i ? player2Color : Colors.white))
              : (tempK == i
                  ? Colors.black
                  : (pKey == i ? player1Color : Colors.white)),
          size: 20,
        ),
      ));
    }
    return tempWidget;
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  final String type;

  MyCustomClipper(this.type);

  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    Path path = Path();

    if (type == "LEFT") {
      path.lineTo(w, 0);
      path.quadraticBezierTo(w / 7, h / 2, w, h);
      path.lineTo(0, h);
      path.close();
    } else if (type == "RIGHT") {
      path.quadraticBezierTo(w - w / 7, h / 2, 0, h);
      path.lineTo(w, h);
      path.lineTo(w, 0);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
