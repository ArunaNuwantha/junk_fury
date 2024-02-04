import 'dart:async';
import 'dart:developer';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:junk_fury/flame_game/junk_fury.dart';
import 'package:logging/logging.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/score.dart';
import '../style/palette.dart';

class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late int score;

  @override
  void initState() {
    super.initState();
    score = 0;
    _startOfPlay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    _log.log(Level.INFO, "game started");
    return IgnorePointer(
      ignoring: _duringCelebration,
      child: Scaffold(
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
      ),
    );
  }

  Future<void> _playerWon() async {
    final score = Score(DateTime.now().difference(_startOfPlay));

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}
