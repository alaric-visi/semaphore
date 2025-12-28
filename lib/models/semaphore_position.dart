class SemaphorePosition {
  final double leftAngle;
  final double rightAngle;
  final String character;

  const SemaphorePosition({
    required this.leftAngle,
    required this.rightAngle,
    required this.character,
  });

  bool get isSpace => character == ' ';

  @override
  String toString() => 'SemaphorePosition($character: L$leftAngle° R$rightAngle°)';
}