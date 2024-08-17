import 'package:flutter/foundation.dart';
import 'dart:html' as html;

double gameWidth = kIsWeb ? html.window.innerWidth!.toDouble() : 820.0;
double gameHeight = kIsWeb ? html.window.innerHeight!.toDouble() : 1600.0;
double playerStep = gameWidth * 0.04;
double playerSize = kIsWeb ? html.window.innerWidth!.toDouble() / 25 : 128;
double garbageSize = kIsWeb ? html.window.innerWidth!.toDouble() / 40 : 48;
