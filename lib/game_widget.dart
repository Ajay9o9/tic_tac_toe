import 'package:flutter/material.dart';

class GameWidget extends StatefulWidget {
  const GameWidget({Key? key}) : super(key: key);

  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  var tiles = List.filled(9, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                for (var i = 0; i < 9; i++)
                  InkWell(
                    onTap: () {
                      setState(() {
                        tiles[i] = 1;
                        runAi();
                      });
                    },
                    child: Center(
                      child: Text(
                        tiles[i] == 0
                            ? ''
                            : tiles[i] == 1
                                ? 'X'
                                : 'O',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                isWinning(1, tiles)
                    ? "You Won"
                    : isWinning(2, tiles)
                        ? "Your Lost"
                        : "Your move",
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    tiles = List.filled(9, 0);
                  });
                },
                child: Text('Restart'),
              )
            ],
          )
        ],
      ),
    );
  }

  void runAi() async {
    await Future.delayed(Duration(milliseconds: 200));

    int? winning;
    int? blocking;
    int? normal;

    for (var i = 0; i < 9; i++) {
      var val = tiles[i];

      if (val > 0) {
        continue;
      }

      var future = [...tiles]..[i] = 2;

      if (isWinning(2, future)) {
        winning = i;
      }

      future[i] = 1;

      if (isWinning(1, future)) {
        blocking = i;
      }

      normal = i;
    }

    var move = winning ?? blocking ?? normal;

    if (move != null) {
      setState(() {
        tiles[move] = 2;
      });
    }
  }

  bool isWinning(int who, List<int> tiles) {
    return (tiles[0] == who && tiles[1] == who && tiles[2] == who) ||
        (tiles[3] == who && tiles[4] == who && tiles[5] == who) ||
        (tiles[6] == who && tiles[7] == who && tiles[8] == who) ||
        (tiles[0] == who && tiles[4] == who && tiles[8] == who) ||
        (tiles[2] == who && tiles[4] == who && tiles[6] == who) ||
        (tiles[0] == who && tiles[3] == who && tiles[6] == who) ||
        (tiles[1] == who && tiles[4] == who && tiles[7] == who) ||
        (tiles[2] == who && tiles[5] == who && tiles[8] == who);
  }
}
