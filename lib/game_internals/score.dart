/// Encapsulates a score and the arithmetic to compute it.
class Score {
  final int score;

  final Duration duration;

  factory Score(Duration duration) {
    // The higher the difficulty, the higher the score.
    var score = 0;
    return Score._(score, duration);
  }

  const Score._(this.score, this.duration);

  String get formattedTime {
    final buf = StringBuffer();
    if (duration.inHours > 0) {
      buf.write('${duration.inHours}');
      buf.write(':');
    }
    final minutes = duration.inMinutes % Duration.minutesPerHour;
    if (minutes > 9) {
      buf.write('$minutes');
    } else {
      buf.write('0');
      buf.write('$minutes');
    }
    buf.write(':');
    buf.write((duration.inSeconds % Duration.secondsPerMinute)
        .toString()
        .padLeft(2, '0'));
    return buf.toString();
  }

  @override
  String toString() => 'Score<$score,$formattedTime>';
}
