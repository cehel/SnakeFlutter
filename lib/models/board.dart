import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';
import 'package:snake/models/point.dart';
import 'package:snake/models/score.dart';
import 'package:snake/models/snake.dart';
import 'package:snake/models/apple.dart';
import 'package:snake/models/homepage.dart';
import 'package:snake/models/endgame.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  var _gameState = GAMESTATE.HOMEPAGE;
  var _snakePosition = List();
  var _direction;
  var _score = 0;
  var _highScore = 0;
  var _tick = 300;
  Timer _timer;
  Point _applePosition;
  Random randomGenerator = Random();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (_direction == RICHTUNG.RECHTS || _direction == RICHTUNG.LINKS) {
          _changeDirection(details);
        }
      },
      onHorizontalDragUpdate: (details) {
        if (_direction == RICHTUNG.OBEN || _direction == RICHTUNG.UNTEN) {
          _changeDirection(details);
        }
      },
      onTap: () {
        if (_gameState == GAMESTATE.HOMEPAGE) {
          _changeGameState(GAMESTATE.INIT);
        } else if (_gameState == GAMESTATE.DIED) {
          _reset();
        }
      },
      child: Container(
        color: Colors.green[500],
        width: BOARD_WIDTH,
        height: BOARD_HEIGHT,
        child: _getGameState(),
      ),
    );
  }

  Widget _getGameState() {
    var child;
    switch (_gameState) {
      case GAMESTATE.HOMEPAGE:
        {
          _getHighScore();
          child = HomePage(_highScore);
          print(_gameState);
          break;
        }
      case GAMESTATE.INIT:
        {
          _getHighScore();
          _gameInit();
          print(_gameState);
          break;
        }
      case GAMESTATE.RUNNING:
        {
          var counter = 0;
          List<Transform> snakeAndApple = List();
          _snakePosition.forEach((i) {
            snakeAndApple.insert(
              0,
              _getSnakeWidget(i, counter),
            );
            counter++;
          });
          snakeAndApple.add(_getAppleWidget());

          Transform scoreWidget = score(_score);
          snakeAndApple.add(scoreWidget);
          child = Stack(children: snakeAndApple);

          print(_gameState);
          break;
        }
      case GAMESTATE.VICTORY:
        {
          child = EndGame(_gameState, _score, _highScore);
          print(_gameState);
          break;
        }
      case GAMESTATE.DIED:
        {
          if (_score > _highScore) {
            _setHighScore(_score);
          }

          _timer.cancel();
          child = EndGame(_gameState, _score, _highScore);

          print(_gameState);
          break;
        }
    }
    return child;
  }

  _getHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedHighscore = prefs.getInt('highscore') ?? 0;
    if (savedHighscore > _highScore) {
      setState(() {
        _highScore = savedHighscore;
      });
    }
  }

  _setHighScore(score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highscore', score);
  }

  void _gameInit() {
    var _allDirection = RICHTUNG.values;
    _direction = _allDirection[randomGenerator.nextInt(_allDirection.length)];
    _getHighScore();
    _changeGameState(GAMESTATE.RUNNING);
    _generateApple();
    _snakePosInit();
    _move();
  }

  void _snakePosInit() {
    var x = randomGenerator.nextInt(BOARD_WIDTH ~/ SNAKE_SIZE - 1).toDouble();
    var y = randomGenerator.nextInt(BOARD_HEIGHT ~/ SNAKE_SIZE - 1).toDouble();
    setState(() {
      _snakePosition.insert(0, Point(x, y, _direction));
    });
  }

  void _generateApple() {
    var x = randomGenerator.nextInt(BOARD_WIDTH ~/ SNAKE_SIZE - 1).toDouble();
    var y = randomGenerator.nextInt(BOARD_HEIGHT ~/ SNAKE_SIZE - 1).toDouble();
    bool _inSnakeBody = false;
    for (var i = 0; i < _snakePosition.length; i++) {
      if (_snakePosition[i].x == x && _snakePosition[i].y == y) {
        _inSnakeBody = true;
        break;
      }
    }
    if (_inSnakeBody) {
      _generateApple();
    } else {
      setState(() {
        _applePosition = Point(x, y, _direction);
      });
    }
  }

  double _getSnakeWidgetAngle(direction) {
    double angle;
    if (direction == RICHTUNG.OBEN) {
      angle = 0;
    } else if (direction == RICHTUNG.RECHTS) {
      angle = 90 * pi / 180;
    } else if (direction == RICHTUNG.UNTEN) {
      angle = pi;
    } else if (direction == RICHTUNG.LINKS) {
      angle = -90 * pi / 180;
    }
    return angle;
  }

  Widget _getSnakeWidget(i, counter) {
    print('_getSnakeWidget');
    String choice;
    double angle = _getSnakeWidgetAngle(i.direction);

    if (counter == 0) {
      choice = 'head';
      return Transform(
        alignment: FractionalOffset.center,
        transform:
        Matrix4.translationValues(i.x * SNAKE_SIZE, i.y * SNAKE_SIZE, 1)
          ..rotateZ(angle),
        child: Snake(choice),
      );
    } else if (counter == _snakePosition.length - 1) {
      choice = 'tail';
      return Transform(
        alignment: FractionalOffset.center,
        transform:
        Matrix4.translationValues(i.x * SNAKE_SIZE, i.y * SNAKE_SIZE, 1)
          ..rotateZ(
              _getSnakeWidgetAngle(_snakePosition[counter - 1].direction)),
        child: Snake(choice),
      );
    } else {
      choice = 'body';
      return Transform(
        alignment: FractionalOffset.center,
        transform:
        Matrix4.translationValues(i.x * SNAKE_SIZE, i.y * SNAKE_SIZE, 1)
          ..rotateZ(angle),
        child: Snake(choice),
      );
    }
  }

  Widget _getAppleWidget() {
    print('_getAppleWidget()');
    return Transform.translate(
      offset:
      Offset(_applePosition.x * APPLE_SIZE, _applePosition.y * APPLE_SIZE),
      child: Apple(),
    );
  }

  // _timerTick(framerate) {
  //   if (_isSelfCollision()) {
  //     _changeGameState(GAMESTATE.DIED);
  //   } else {
  //     _move();
  //   }
  //   // await Future.delayed(Duration(milliseconds: framerate),_timerTick(framerate));
  //   Timer(Duration(milliseconds: framerate),(){_timerTick(framerate);});
  // }

  void _move() {
    try {
      print("_move()");
      var neuePosition = _neuePositionPosition();
      setState(() {
        if (_isSelfCollision()) {
          _changeGameState(GAMESTATE.DIED);
          return;
        }
        if (_appleIsEaten(neuePosition)) {
          _generateApple();
          _score++;
          _tick <= 50 ? _tick = 50 : _tick -= 5;
          _snakePosition.insert(0, neuePosition);
        } else {
          _snakePosition.insert(0, neuePosition);
          _snakePosition.removeLast();
        }
      });
    } catch (e) {
      print(e);
    }
    _timer = Timer(Duration(milliseconds: _tick), () {
      _move();
    });
  }

  bool _appleIsEaten(neuePosition) {
    if ((neuePosition.x == _applePosition.x && neuePosition.y == _applePosition.y) ||
        _applePosition == null) {
      return true;
    }
    return false;
  }

  //nouvelle positions de la tete
  Point _neuePositionPosition() {
    print('_neuePositionPosition()');
    var aktuellePosition = _snakePosition.first;
    var x = aktuellePosition.x;
    var y = aktuellePosition.y;
    Point neuePosition = Point(x, y, _direction);
    print(neuePosition.direction);

    // Ou est la nouvelle tete dépendent de la direction
    // remplir...
    switch(_direction) {
      case(RICHTUNG.LINKS):
        {
          neuePosition.x = aktuellePosition.x-1;
          break;
        }
      case(RICHTUNG.OBEN):
        {
          neuePosition.y = aktuellePosition.y-1;
          break;
        }
      case(RICHTUNG.UNTEN):{
          neuePosition.y = aktuellePosition.y+1;
          break;
      }
      case(RICHTUNG.RECHTS):{
        neuePosition.x= aktuellePosition.x+1;
        break;
      }

    }


    // quand est la nouvelle tete est hors de la planche?
    //qu'est-ce qu'il ce passe si la nouvelle tete est hors de la planche?
    //remplir..
    if (neuePosition.x >= GRID_X) {
      neuePosition.x = neuePosition.x % GRID_X;
    } else if (neuePosition.x < 0) {
      neuePosition.x = GRID_X - 1;
    }
    if (neuePosition.y >= GRID_Y) {
      neuePosition.y = neuePosition.y % GRID_Y;
    } else if (neuePosition.y < 0) {
      neuePosition.y = GRID_Y - 1;
    }
    return neuePosition;
  }

  //
  void _changeDirection(details) {
    var _swipe = details.delta.direction;
    if (-pi / 4 < _swipe && _swipe < pi / 4) {
      if (_direction == RICHTUNG.LINKS) {
        _direction = RICHTUNG.LINKS;
      } else {
        setState(() {
          _direction = RICHTUNG.RECHTS;
        });
      }
    } else if (-3 * pi / 4 < _swipe && _swipe > 3 * pi / 4) {
      if (_direction == RICHTUNG.RECHTS) {
        _direction = RICHTUNG.RECHTS;
      } else {
        setState(() {
          _direction = RICHTUNG.LINKS;
        });
      }
    } else if (-3 * pi / 4 < _swipe && _swipe < -pi / 4) {
      if (_direction == RICHTUNG.UNTEN) {
        _direction = RICHTUNG.UNTEN;
        return;
      } else {
        setState(() {
          _direction = RICHTUNG.OBEN;
        });
      }
    } else if (pi / 4 < _swipe && _swipe < 3 * pi / 4) {
      if (_direction == RICHTUNG.OBEN) {
        _direction = RICHTUNG.OBEN;
        return;
      } else {
        setState(() {
          _direction = RICHTUNG.UNTEN;
        });
      }
    }
  }

  //Kollidiert mit sich selbst
  bool _isSelfCollision() {
    var head = _snakePosition.first;
    var body = _snakePosition.sublist(1);
    for (var i = 0; i < body.length; i++) {
      var x = body[i].x;
      var y = body[i].y;
      if (head.x == x && head.y == y) {
        return true;
      }
    }
    return false;
  }

  // bool _isWallCollision() {
  //   var head = _snakePosition.first;
  //   if (head.x < 0 || head.x >= GRID_X || head.y < 0 || head.y >= GRID_Y) {
  //     return true;
  //   }
  //   return false;
  // }

  void _changeGameState(gamestate) {
    setState(() {
      _gameState = gamestate;
    });
  }

  void _reset() {
    setState(() {
      _snakePosition = List();
      _gameState = GAMESTATE.HOMEPAGE;
      _applePosition = null;
      _score = 0;
      _direction = RICHTUNG
          .values[randomGenerator.nextInt(RICHTUNG.values.length - 1)];
      _tick = 300;
    });
  }
}

