// ignore_for_file: avoid_print

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Michiganify
// TODO: Animation
// tile stacking on merge and new game (something with Stack and no pop)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('stats');
  await Hive.openBox('ongoingGame');
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

var tileImages = {
  2: 'assets/arthur.png',
  4: 'assets/kloosterman.jpeg',
  8: 'assets/juett.jpeg',
  16: 'assets/awdeorio.jpg',
  32: 'assets/graetz.jpg',
  64: 'assets/mdarden.jpeg',
  128: 'assets/paoletti.jpg',
  256: 'assets/peikert.jpg',
  512: 'assets/beau.jpeg',
  2048: 'assets/ono.png'
};

Map<int, Color> tileColors = {
  0: const Color.fromARGB(255, 19, 59, 95),
  2: const Color.fromARGB(255, 226, 219, 212),
  4: const Color.fromARGB(255, 186, 186, 186),
  8: const Color.fromARGB(255, 255, 203, 5),
  16: const Color.fromARGB(255, 234, 188, 6),
  32: const Color.fromARGB(255, 247, 123, 95),
  64: const Color.fromARGB(255, 247, 95, 58),
  128: const Color.fromARGB(255, 237, 208, 116),
  256: const Color.fromARGB(255, 237, 208, 116),
  512: const Color.fromARGB(255, 237, 208, 116),
  1024: const Color.fromARGB(255, 237, 208, 116),
  2048: const Color.fromARGB(255, 237, 208, 116),
};

Map<int, Color> fontColors = {
  0: Colors.white,
  2: Colors.white,
  4: Colors.white,
  8: Colors.white,
  16: Colors.black,
  32: Colors.white,
  64: Colors.black,
  128: Colors.white,
  256: Colors.white,
  512: Colors.white,
  1024: Colors.white,
  2048: Colors.white,
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
  Box myBox = Hive.box('stats');
  Box myOngoingGameBox = Hive.box('ongoingGame');
  int score = 0;
  List<List<Tile>> grid = List.generate(
      4,
      (col) => List.generate(4, (row) {
            return Tile(row, col, 0);
          }));
  late double gridSize = MediaQuery.of(context).size.width < 700 ? 353.7 : 450;
  late double tileSize = gridSize / 4;

  @override
  void initState() {
    myOngoingGameBox.clear();
    if (!myBox.containsKey('highscore')) {
      myBox.put('highscore', 0);
    }

    if (myOngoingGameBox.length != 0) {
      score = myOngoingGameBox.get('score');
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          grid[i][j].val = myOngoingGameBox.getAt(i * 4 + j);
        }
      }
    } else {
      createNewTile(2);
    }
    // grid[0][0].val = 2;
    // grid[0][1].val = 4;
    // grid[0][2].val = 8;
    // grid[3][3].val = 16;
    // grid[1][0].val = 32;
    // grid[1][1].val = 64;
    // grid[1][2].val = 128;
    // grid[1][3].val = 256;
    // grid[2][0].val = 512;
    // grid[2][1].val = 1024;
    // grid[2][2].val = 2048;
    // grid[2][3].val = 128;
    // grid[3][0].val = 256;
    // grid[3][1].val = 512;
    // grid[3][2].val = 1024;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gridSize = MediaQuery.of(context).size.width < 600 ? 353.7 : 450;
    tileSize = gridSize / 4;
    myOngoingGameBox.clear();
    myOngoingGameBox.put('score', score);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        myOngoingGameBox.add(grid[i][j].val);
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 39, 76),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage("assets/blockM.png"),
                    // specify width and height for the image
                    width: 75,
                    height: 75,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "EECS",
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      GlowText(
                        " 2",
                        blurRadius: 10,
                        style: TextStyle(
                            fontSize: 50,
                            color: Color.fromARGB(255, 66, 133, 244),
                            fontWeight: FontWeight.bold),
                      ),
                      GlowText(
                        "0",
                        blurRadius: 10,
                        style: TextStyle(
                            fontSize: 50,
                            color: Color.fromARGB(255, 52, 168, 83),
                            fontWeight: FontWeight.bold),
                      ),
                      GlowText(
                        "4",
                        blurRadius: 10,
                        style: TextStyle(
                            fontSize: 50,
                            color: Color.fromARGB(255, 251, 188, 5),
                            fontWeight: FontWeight.bold),
                      ),
                      GlowText(
                        "8",
                        blurRadius: 10,
                        style: TextStyle(
                            fontSize: 50,
                            color: Color.fromARGB(255, 234, 67, 53),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 165,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Color.fromARGB(255, 19, 59, 95),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            const Text("SCORE",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 203, 5),
                                  fontWeight: FontWeight.w800,
                                )),
                            Text(
                              "$score",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 165,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          color: Color.fromARGB(255, 19, 59, 95),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            const Text("BEST",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 203, 5),
                                  fontWeight: FontWeight.w800,
                                )),
                            GlowText(
                              blurRadius: 10,
                              myBox.get('highscore').toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: gridSize,
                    height: gridSize,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 0, 32, 61),
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity! > 250) {
                          print("swipe: right");
                          swipeRight();
                          createNewTile(1);
                          checkIfLost();
                        }
                        if (details.primaryVelocity! < -250) {
                          print("swipe: left");
                          swipeLeft();
                          createNewTile(1);
                          checkIfLost();
                        }
                      },
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity! < -250) {
                          print("swipe: up");
                          swipeUp();
                          createNewTile(1);
                          checkIfLost();
                        }
                        if (details.primaryVelocity! > 250) {
                          print("swipe: down");
                          swipeDown();
                          createNewTile(1);
                          checkIfLost();
                        }
                      },
                      child: GridView.builder(
                        itemCount: 16,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        itemBuilder: (context, index) {
                          int x = index ~/ 4;
                          int y = index % 4;
                          Tile tile = grid[x][y];
                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: tileColors[tile.val],
                            ),
                            child: Center(
                              child: tile.val == 0
                                  ? Container()
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Stack(
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                tileImages[tile.val]!),
                                            width: tileSize,
                                            height: tileSize,
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            child: Text(
                                              tile.val != 0
                                                  ? tile.val.toString()
                                                  : "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: fontColors[tile.val],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                            backgroundColor: const MaterialStatePropertyAll(
                                Color.fromARGB(255, 19, 59, 95)),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            elevation: const MaterialStatePropertyAll(0),
                          ),
                          onPressed: () {
                            launchUrl(
                              Uri.parse(
                                  "https://maizepages.umich.edu/organization/dsc-at-u-m"),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GlowText(
                                "G",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 66, 133, 244),
                                    fontWeight: FontWeight.bold),
                              ),
                              GlowText(
                                "o",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 234, 67, 53),
                                    fontWeight: FontWeight.bold),
                              ),
                              GlowText(
                                "o",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 251, 188, 5),
                                    fontWeight: FontWeight.bold),
                              ),
                              GlowText(
                                "g",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 66, 133, 244),
                                    fontWeight: FontWeight.bold),
                              ),
                              GlowText(
                                "l",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 52, 168, 83),
                                    fontWeight: FontWeight.bold),
                              ),
                              GlowText(
                                "e",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 234, 67, 53),
                                    fontWeight: FontWeight.bold),
                              ),
                              GlowText(
                                " @ UM",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                      const SizedBox(width: 50),
                      ElevatedButton(
                        onPressed: () {
                          startNewGame();
                        },
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(
                              Color.fromARGB(255, 19, 59, 95)),
                          shape: MaterialStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          elevation: const MaterialStatePropertyAll(0),
                        ),
                        child: const Text(
                          "Play Again",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void swipeRight() {
    for (int i = 0; i < grid.length; i++) {
      var lastNum = -1;
      var lastNumIdx = -1; // needed for 2 0 2 0 case
      for (int j = grid.length - 1; j >= 0; j--) {
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
                score += grid[i][lastNumIdx].val;
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
          // 2 2 16 4 case
          // merge
          setState(() {
            grid[i][lastNumIdx].val = grid[i][j].val * 2;
            grid[i][j].val = 0;
            score += grid[i][lastNumIdx].val;
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

  void swipeUp() {
    for (int j = 0; j < grid.length; j++) {
      var lastNum = -1;
      var lastNumIdx = -1; // needed for 2 0 2 0 case
      for (int i = 0; i < grid.length; i++) {
        if (grid[i][j].val == 0) {
          int scout = i + 1;
          while (scout < 4 && grid[scout][j].val == 0) {
            scout++;
          }
          if (scout < 4) {
            if (grid[scout][j].val == lastNum) {
              // merge
              setState(() {
                grid[lastNumIdx][j].val = grid[scout][j].val * 2;
                grid[scout][j].val = 0;
                score += grid[lastNumIdx][j].val;
              });
              lastNum = -1;
              lastNumIdx = -1;
            } else {
              // move left (mark lastNum)
              lastNum = grid[scout][j].val;
              lastNumIdx = i;
              setState(() {
                grid[i][j].val = grid[scout][j].val;
                grid[scout][j].val = 0;
              });
            }
          }
        } else if (grid[i][j].val == lastNum) {
          // 2 2 0 0 case
          // merge
          setState(() {
            grid[lastNumIdx][j].val = grid[i][j].val * 2;
            grid[i][j].val = 0;
            score += grid[lastNumIdx][j].val;
          });
          lastNum = -1;
          lastNumIdx = -1;
          i--;
        } else {
          // 2 0 2 0 case, first is nonzero
          lastNum = grid[i][j].val;
          lastNumIdx = i;
        }
      }
    }
  }

  void swipeDown() {
    for (int j = 0; j < grid.length; j++) {
      var lastNum = -1;
      var lastNumIdx = -1; // needed for 2 0 2 0 case
      for (int i = grid.length - 1; i >= 0; i--) {
        if (grid[i][j].val == 0) {
          int scout = i - 1;
          while (scout >= 0 && grid[scout][j].val == 0) {
            scout--;
          }
          if (scout >= 0) {
            if (grid[scout][j].val == lastNum) {
              // merge
              setState(() {
                grid[lastNumIdx][j].val = grid[scout][j].val * 2;
                grid[scout][j].val = 0;
                score += grid[lastNumIdx][j].val;
              });
              lastNum = -1;
              lastNumIdx = -1;
            } else {
              // move left (mark lastNum)
              lastNum = grid[scout][j].val;
              lastNumIdx = i;
              setState(() {
                grid[i][j].val = grid[scout][j].val;
                grid[scout][j].val = 0;
              });
            }
          }
        } else if (grid[i][j].val == lastNum) {
          // 2 2 0 0 case
          // merge
          setState(() {
            grid[lastNumIdx][j].val = grid[i][j].val * 2;
            grid[i][j].val = 0;
            score += grid[lastNumIdx][j].val;
          });
          lastNum = -1;
          lastNumIdx = -1;
          i++;
        } else {
          // 2 0 2 0 case, first is nonzero
          lastNum = grid[i][j].val;
          lastNumIdx = i;
        }
      }
    }
  }

  // also figure out how pt system works in 2048

  void swipeLeft() {
    for (int i = 0; i < grid.length; i++) {
      var lastNum = -1;
      var lastNumIdx = -1; // needed for 2 0 2 0 case
      for (int j = 0; j < grid.length; j++) {
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
                score += grid[i][lastNumIdx].val;
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
            score += grid[i][lastNumIdx].val;
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

  // Create num number of tiles
  void createNewTile(int num) {
    if (isBoardFull()) {
      return;
    }
    var rng = Random();
    for (int i = 0; i < num; i++) {
      int index = rng.nextInt(16); // Generate a random number from 0 to 15
      int x = index ~/ 4; // Calculate x coordinate
      int y = index % 4; // Calculate y coordinate

      while (grid[x][y].val != 0) {
        index = (index + 1) % 16; // Wrap around if necessary
        x = index ~/ 4; // Recalculate x coordinate
        y = index % 4; // Recalculate y coordinate
      }

      if (rng.nextInt(10) == 1) {
        // 10% chance of 4
        grid[x][y].val = 4;
      } else {
        grid[x][y].val = 2;
      }
    }
  }

  void startNewGame() {
    if (score > myBox.get('highscore')) {
      myBox.put('highscore', score);
    }
    // Clear tiles
    setState(() {
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          grid[i][j].val = 0;
        }
      }
      // Set score to 0
      score = 0;
      // Generate 2 new tiles
      createNewTile(2);
    });
  }

  void checkIfLost() {
    if (!isBoardFull()) {
      return;
    }

    // check if merges possible
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (i != 0) {
          if (grid[i][j].val == grid[i - 1][j].val) {
            return;
          }
        }
        if (i != 3) {
          if (grid[i][j].val == grid[i + 1][j].val) {
            return;
          }
        }
        if (j != 0) {
          if (grid[i][j].val == grid[i][j - 1].val) {
            return;
          }
        }
        if (j != 3) {
          if (grid[i][j].val == grid[i][j + 1].val) {
            return;
          }
        }
      }
    }

    // Lost game
    if (score > myBox.get('highscore')) {
      myBox.put('highscore', score);
    }

    showLosePopup();
    return;
  }

  bool isBoardFull() {
    // check if full
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (grid[i][j].val == 0) {
          return false;
        }
      }
    }
    return true;
  }

  showLosePopup() {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) {
        return Container(
          color: const Color.fromARGB(255, 25, 76, 124).withOpacity(0.7),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Game Over!",
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 30)),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    startNewGame();
                  },
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(
                        Color.fromARGB(255, 14, 43, 69)),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    elevation: const MaterialStatePropertyAll(0),
                  ),
                  child: const Text(
                    "Try again",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
