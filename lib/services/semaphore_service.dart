import 'package:semaphoreflow/models/semaphore_position.dart';

class SemaphoreService {
  static final SemaphoreService _instance = SemaphoreService._internal();
  factory SemaphoreService() => _instance;
  SemaphoreService._internal();

  // FINAL CORRECTED MAPPING based on painter logic (0° = Down)
  static const Map<String, SemaphorePosition> _positions = {
    // Letters
    'a': SemaphorePosition(leftAngle: 0, rightAngle: 45, character: 'A'),       // LH Down, RH Low
    'b': SemaphorePosition(leftAngle: 0, rightAngle: 90, character: 'B'),       // LH Down, RH Out
    'c': SemaphorePosition(leftAngle: 0, rightAngle: 135, character: 'C'),      // LH Down, RH High
    'd': SemaphorePosition(leftAngle: 0, rightAngle: 180, character: 'D'),      // LH Down, RH Up
    'e': SemaphorePosition(leftAngle: 135, rightAngle: 0, character: 'E'),      // LH High, RH Down
    'f': SemaphorePosition(leftAngle: 90, rightAngle: 0, character: 'F'),       // LH Out, RH Down
    'g': SemaphorePosition(leftAngle: 45, rightAngle: 0, character: 'G'),       // LH Low, RH Down
    'h': SemaphorePosition(leftAngle: 315, rightAngle: 90, character: 'H'),     // LH Across Low, RH Out
    'i': SemaphorePosition(leftAngle: 315, rightAngle: 180, character: 'I'),     // LH Across Low, RH Up
    'j': SemaphorePosition(leftAngle: 90, rightAngle: 180, character: 'J'),      // LH Out, RH Up (Alphabetic)
    'k': SemaphorePosition(leftAngle: 180, rightAngle: 45, character: 'K'),      // LH Up, RH Low
    'l': SemaphorePosition(leftAngle: 135, rightAngle: 45, character: 'L'),      // LH High, RH Low
    'm': SemaphorePosition(leftAngle: 90, rightAngle: 45, character: 'M'),       // LH Out, RH Low
    'n': SemaphorePosition(leftAngle: 45, rightAngle: 45, character: 'N'),       // LH Low, RH Low
    'o': SemaphorePosition(leftAngle: 225, rightAngle: 90, character: 'O'),      // LH Across High, RH Out
    'p': SemaphorePosition(leftAngle: 180, rightAngle: 90, character: 'P'),      // LH Up, RH Out
    'q': SemaphorePosition(leftAngle: 135, rightAngle: 90, character: 'Q'),      // LH High, RH Out
    'r': SemaphorePosition(leftAngle: 90, rightAngle: 90, character: 'R'),       // LH Out, RH Out
    's': SemaphorePosition(leftAngle: 45, rightAngle: 90, character: 'S'),       // LH Low, RH Out
    't': SemaphorePosition(leftAngle: 180, rightAngle: 135, character: 'T'),     // LH Up, RH High
    'u': SemaphorePosition(leftAngle: 135, rightAngle: 135, character: 'U'),     // LH High, RH High
    'v': SemaphorePosition(leftAngle: 45, rightAngle: 180, character: 'V'),       // LH Low, RH Up
    'w': SemaphorePosition(leftAngle: 90, rightAngle: 225, character: 'W'),      // LH Out, RH Across High
    'x': SemaphorePosition(leftAngle: 45, rightAngle: 225, character: 'X'),       // LH Low, RH Across High
    'y': SemaphorePosition(leftAngle: 90, rightAngle: 135, character: 'Y'),      // LH Out, RH High
    'z': SemaphorePosition(leftAngle: 90, rightAngle: 315, character: 'Z'),      // LH Out, RH Across Low

    // Numbers (Shared positions)
    '1': SemaphorePosition(leftAngle: 0, rightAngle: 45, character: '1'),
    '2': SemaphorePosition(leftAngle: 0, rightAngle: 90, character: '2'),
    '3': SemaphorePosition(leftAngle: 0, rightAngle: 135, character: '3'),
    '4': SemaphorePosition(leftAngle: 0, rightAngle: 180, character: '4'),
    '5': SemaphorePosition(leftAngle: 135, rightAngle: 0, character: '5'),
    '6': SemaphorePosition(leftAngle: 90, rightAngle: 0, character: '6'),
    '7': SemaphorePosition(leftAngle: 45, rightAngle: 0, character: '7'),
    '8': SemaphorePosition(leftAngle: 315, rightAngle: 90, character: '8'),
    '9': SemaphorePosition(leftAngle: 315, rightAngle: 180, character: '9'),
    '0': SemaphorePosition(leftAngle: 180, rightAngle: 45, character: '0'),

    // Special Characters
    ' ': SemaphorePosition(leftAngle: 0, rightAngle: 0, character: ' '), // Rest/Space
  };

  // Returns a list of all valid characters for the quiz
  List<String> get validCharacters {
    // Exclude space character from the quiz
    return _positions.keys.where((c) => c != ' ').toList();
  }

  SemaphorePosition? getPosition(String char) {
    final normalized = char.toLowerCase();
    return _positions[normalized];
  }

  String cleanText(String text) {
    // Allow letters, numbers, and spaces
    return text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), '');
  }

  List<SemaphorePosition> translate(String text) {
    final cleaned = cleanText(text);
    final positions = <SemaphorePosition>[];

    for (int i = 0; i < cleaned.length; i++) {
      final position = getPosition(cleaned[i]);
      if (position != null) {
        positions.add(position);
      }
    }

    return positions;
  }

  bool isValidCharacter(String char) {
    return _positions.containsKey(char.toLowerCase());
  }
}
