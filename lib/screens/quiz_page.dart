import 'dart:math';
import 'package:flutter/material.dart';
import 'package:semaphoreflow/models/semaphore_position.dart';
import 'package:semaphoreflow/services/semaphore_service.dart';
import 'package:semaphoreflow/widgets/flag_display.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _service = SemaphoreService();
  final _random = Random();

  late SemaphorePosition _currentQuestion;
  late List<String> _options;

  int _score = 0;
  int _streak = 0;
  bool _answered = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final validChars = _service.validCharacters;
    final char = validChars[_random.nextInt(validChars.length)];

    _currentQuestion = _service.getPosition(char)!;

    final distractors = <String>{};
    while (distractors.length < 3) {
      final d = validChars[_random.nextInt(validChars.length)];
      if (d != char) distractors.add(d);
    }

    _options = [...distractors, char]..shuffle();
    _answered = false;
    _selectedAnswer = null;
    setState(() {});
  }

  void _handleAnswer(String answer) {
    if (_answered) return;

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (answer.toLowerCase() == _currentQuestion.character.toLowerCase()) {
        _score += 10 + (_streak * 2);
        _streak++;
      } else {
        _streak = 0;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _generateQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildScoreCard('SCORE', '$_score', theme),
                _buildScoreCard('STREAK', '🔥 $_streak', theme),
              ],
            ),
            const SizedBox(height: 32),

            Container(
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: FlagDisplay(
                position: _currentQuestion,
                isActive: true,
                index: 0,
                showLabel: false,
                scale: 0.4, // Further reduced scale to 40%
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'What character is this?',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            LayoutBuilder(builder: (context, constraints) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final option = _options[index];
                  return _buildOptionButton(option, theme);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option, ThemeData theme) {
    final isSelected = _selectedAnswer == option;
    final isCorrect = option.toLowerCase() == _currentQuestion.character.toLowerCase();

    Color backgroundColor = theme.colorScheme.surface;
    Color textColor = theme.colorScheme.onSurface;
    Color borderColor = theme.colorScheme.outline;

    if (_answered) {
      if (isCorrect) {
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green;
        textColor = Colors.green.shade900;
      } else if (isSelected) {
        backgroundColor = Colors.red.shade100;
        borderColor = Colors.red;
        textColor = Colors.red.shade900;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleAnswer(option),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: _answered && (isSelected || isCorrect) ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              option.toUpperCase(),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
