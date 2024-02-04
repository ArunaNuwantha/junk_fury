import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:junk_fury/flame_game/junk_fury.dart';
import 'package:logging/logging.dart';

import '../style/palette.dart';

class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    _log.log(Level.INFO, "game started");
    return Scaffold(
      backgroundColor: palette.backgroundMain,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GameWidget.controlled(
                  gameFactory: JunkFury.new,
                  overlayBuilderMap: {
                    GameState.pause.name: (context, game) {
                      log("game : $game");
                      return const Center(
                        child: Text(
                          'Resume',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontFamily: 'Permanent Marker',
                          ),
                        ),
                      );
                    },
                    GameState.gameOver.name: (context, game) => const Center(
                          child: Text(
                            'G A M E   O V E R',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontFamily: 'Permanent Marker',
                            ),
                          ),
                        ),
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 30,
            left: 16,
            child: InkResponse(
              onTap: () => GoRouter.of(context).push('/settings'),
              child: Image.asset(
                'assets/images/settings.png',
                semanticLabel: 'Settings',
                height: 24,
                width: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
