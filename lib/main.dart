import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'my_game.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MyGame _myGame;

  @override
  void initState() {
    super.initState();
    _myGame = MyGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GameWidget(game: _myGame),
        !_myGame.isGamePause
            ? Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: () {
                    setState(() {
                      _myGame.pauseGame();
                    });
                  },
                ),
              )
            : const SizedBox(),
        _myGame.isGamePause
            ? Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "PAUSED!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.play_arrow,
                          size: 140,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _myGame.resumeGame();
                          });
                        },
                      ),
                    ],
                  ),
                ),
            )
            : const SizedBox(),
      ]),
    );
  }
}
