import 'package:flutter/material.dart';
import 'package:semaphoreflow/services/semaphore_service.dart';
import 'package:semaphoreflow/widgets/flag_display.dart';

class DictionaryPage extends StatelessWidget {
  const DictionaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = SemaphoreService();
    final alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

    return Scaffold(
      body: Scrollbar(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: alphabet.length,
          itemBuilder: (context, index) {
            final char = alphabet[index];
            final position = service.getPosition(char);

            if (position == null) return const SizedBox.shrink();

            return FlagDisplay(
              position: position,
              isActive: true, // Always show in dictionary
              index: index,
            );
          },
        ),
      ),
    );
  }
}
