import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

Map<int, Color> tileColors = {
  0: const Color.fromARGB(255, 205, 192, 181),
  2: const Color.fromARGB(255, 238, 228, 218),
  4: const Color.fromARGB(255, 238, 225, 201),
  8: const Color.fromARGB(255, 243, 178, 122),
  16: const Color.fromARGB(255, 246, 150, 100),
};

Map<int, Color> fontColors = {
  0: const Color.fromARGB(255, 204, 192, 179),
  2: const Color.fromARGB(255, 119, 110, 101),
  4: const Color.fromARGB(255, 119, 110, 101),
  8: Colors.white,
  16: Colors.white,
};

class Tile {
  int x;
  int y;
  int val;

  Tile(this.x, this.y, this.val);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<Tile>> grid = List.generate(
      4,
      (col) => List.generate(4, (row) {
            return Tile(row, col, 0);
          }));
  Iterable<Tile> get flattenedGrid => grid.expand((element) => element);
  late double gridSize = MediaQuery.of(context).size.width * .90;
  late double tileSize = gridSize / 4;
  List<Widget> tiles = [];

  @override
  void initState() {
    grid[0][0].val = 2;

    grid[0][1].val = 2;
    grid[0][2].val = 4;
    grid[3][3].val = 2;
    grid[2][2].val = 4;
    grid[1][2].val = 8;
    grid[2][3].val = 16;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tiles.addAll(flattenedGrid.map(
      (tile) => Positioned(
        top: tile.y * tileSize,
        left: tile.x * tileSize,
        height: tileSize,
        width: tileSize,
        child: Center(
          child: Container(
            height: tileSize - 4 * 2,
            width: tileSize - 4 * 2,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              color: tileColors[tile.val],
            ),
            child: Center(
              child: Text(
                tile.val != 0 ? tile.val.toString() : "",
                style: TextStyle(
                  fontSize: tileSize * 0.45,
                  fontWeight: FontWeight.w800,
                  color: fontColors[tile.val],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 246, 242),
      body: Center(
        child: Container(
          width: gridSize,
          height: gridSize,
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 187, 173, 160),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 250) {
                print("swipe: right");
                swipeRight();
              }
              if (details.primaryVelocity! < -250) {
                print("swipe: left");
                swipeLeft();
              }
            },
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < -250) {
                print("swipe: up");
                // swipeUp();
              }
              if (details.primaryVelocity! > 250) {
                print("swipe: down");
                // swipeDown();
              }
            },
            child: Stack(
              children: tiles,
            ),
          ),
        ),
      ),
    );
  }

  // TODO: Swipe R,U,D

  void swipeRight() {
    for (int i = 0; i < grid.length; i++) {
      var lastNum = -1;
      var lastNumIdx = -1; // needed for 2 0 2 0 case
      for (int j = grid.length - 1; j > 0; j--) {
        if (grid[i][j].val == 0) {
          int scout = j - 1;
          while (scout >= 0 && grid[i][scout].val == 0) {
            scout--;
          }
          if (scout >= 0) {
            if (grid[i][scout].val == lastNum) {
              // merge
              setState(() {
                grid[i][lastNumIdx].val = grid[i][scout].val * 2;
                grid[i][scout].val = 0;
              });
              lastNum = -1;
              lastNumIdx = -1;
            } else {
              // move left (mark lastNum)
              lastNum = grid[i][scout].val;
              lastNumIdx = j;
              setState(() {
                grid[i][j].val = grid[i][scout].val;
                grid[i][scout].val = 0;
              });
            }
          }
        } else if (grid[i][j].val == lastNum) {
          // 2 2 0 0 case
          // merge
          setState(() {
            grid[i][lastNumIdx].val = grid[i][j].val * 2;
            grid[i][j].val = 0;
          });
          lastNum = -1;
          lastNumIdx = -1;
          j++;
        } else {
          // 2 0 2 0 case, first is nonzero
          lastNum = grid[i][j].val;
          lastNumIdx = j;
        }
      }
    }
  }

  // swipeUp();

  // swipeDown();

  // also figure out how pt system works in 2048

  void swipeLeft() {
    for (int i = 0; i < grid.length; i++) {
      var lastNum = -1;
      var lastNumIdx = -1; // needed for 2 0 2 0 case
      for (int j = 0; j < grid.length - 1; j++) {
        if (grid[i][j].val == 0) {
          int scout = j + 1;
          while (scout < 4 && grid[i][scout].val == 0) {
            scout++;
          }
          if (scout < 4) {
            if (grid[i][scout].val == lastNum) {
              // merge
              setState(() {
                grid[i][lastNumIdx].val = grid[i][scout].val * 2;
                grid[i][scout].val = 0;
              });
              lastNum = -1;
              lastNumIdx = -1;
            } else {
              // move left (mark lastNum)
              lastNum = grid[i][scout].val;
              lastNumIdx = j;
              setState(() {
                grid[i][j].val = grid[i][scout].val;
                grid[i][scout].val = 0;
              });
            }
          }
        } else if (grid[i][j].val == lastNum) {
          // 2 2 0 0 case
          // merge
          setState(() {
            grid[i][lastNumIdx].val = grid[i][j].val * 2;
            grid[i][j].val = 0;
          });
          lastNum = -1;
          lastNumIdx = -1;
          j--;
        } else {
          // 2 0 2 0 case, first is nonzero
          lastNum = grid[i][j].val;
          lastNumIdx = j;
        }
      }
    }
  }
}
