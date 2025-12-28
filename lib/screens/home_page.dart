import 'package:flutter/material.dart';
import 'package:semaphoreflow/screens/dictionary_page.dart';
import 'package:semaphoreflow/screens/quiz_page.dart';
import 'package:semaphoreflow/screens/translator_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = const [
    TranslatorPage(),
    DictionaryPage(),
    QuizPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flag_rounded,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Text(
              _getTitle(_currentIndex),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.translate_rounded),
            label: 'Translate',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Dictionary',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_rounded),
            label: 'Quiz',
          ),
        ],
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Semaphore';
      case 1:
        return 'Dictionary';
      case 2:
        return 'Quiz Mode';
      default:
        return 'Semaphore';
    }
  }
}
