import 'package:flutter/material.dart';
import 'package:semaphoreflow/models/translation_state.dart';

class StatusBar extends StatelessWidget {
  final TranslationState state;
  final int currentIndex;
  final int totalCharacters;

  const StatusBar({
    super.key,
    required this.state,
    required this.currentIndex,
    required this.totalCharacters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusIndicator(context),
          _buildProgressIndicator(context),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    final theme = Theme.of(context);
    Color color;
    String text;

    switch (state) {
      case TranslationState.idle:
        color = Colors.grey;
        text = 'Idle';
        break;
      case TranslationState.translating:
        color = Colors.blue;
        text = 'Translating';
        break;
      case TranslationState.paused:
        color = Colors.orange;
        text = 'Paused';
        break;
      case TranslationState.complete:
        color = Colors.green;
        text = 'Complete';
        break;
    }

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          text,
          style: theme.textTheme.labelLarge,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      '$currentIndex/$totalCharacters',
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
