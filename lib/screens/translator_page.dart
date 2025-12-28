import 'package:flutter/material.dart';
import 'package:semaphoreflow/models/semaphore_position.dart';
import 'package:semaphoreflow/services/semaphore_service.dart';
import 'package:semaphoreflow/widgets/flag_display.dart';
import 'package:semaphoreflow/widgets/status_bar.dart';
import 'package:semaphoreflow/widgets/semaphore_man_painter.dart';
import 'package:semaphoreflow/theme.dart';

import '../models/translation_state.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> with TickerProviderStateMixin {
  final _semaphoreService = SemaphoreService();
  final _textController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Alignment> _alignmentAnimation;

  TranslationState _state = TranslationState.idle;
  List<SemaphorePosition> _positions = [];
  int _currentIndex = 0;
  double _playbackSpeed = 800.0;

  @override
  void initState() {
    super.initState();
    _textController.text = 'HELLO WORLD';

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _alignmentAnimation = Tween<Alignment>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleTranslate() {
    if (_textController.text.trim().isEmpty) return;

    final cleaned = _semaphoreService.cleanText(_textController.text);
    final positions = _semaphoreService.translate(cleaned);

    setState(() {
      _positions = positions;
      _currentIndex = 0;
      _state = TranslationState.translating;
    });

    _animateTranslation();
  }

  void _animateTranslation() async {
    if (_state != TranslationState.translating) return;

    while (_currentIndex < _positions.length && _state == TranslationState.translating) {
      await Future.delayed(Duration(milliseconds: _playbackSpeed.round()));
      if (mounted && _state == TranslationState.translating) {
        setState(() {
          _currentIndex++;
        });
      }
    }

    if (mounted && _currentIndex >= _positions.length) {
      setState(() {
        _state = TranslationState.complete;
      });
    }
  }

  void _handlePause() {
    setState(() {
      _state = _state == TranslationState.translating
          ? TranslationState.paused
          : TranslationState.translating;
    });

    if (_state == TranslationState.translating) {
      _animateTranslation();
    }
  }

  void _handleClear() {
    setState(() {
      _textController.clear();
      _positions = [];
      _currentIndex = 0;
      _state = TranslationState.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isAnimating = _state == TranslationState.translating;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input Section
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceVariant,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INPUT TEXT',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _textController,
                    maxLines: 3,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter text to translate...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                    ),
                    onSubmitted: (_) => _handleTranslate(),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Speed: ${_playbackSpeed.round()}ms',
                              style: theme.textTheme.labelSmall,
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                trackHeight: 2,
                              ),
                              child: Slider(
                                value: _playbackSpeed,
                                min: 200,
                                max: 2000,
                                onChanged: (value) {
                                  setState(() => _playbackSpeed = value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      FilledButton.icon(
                        onPressed: (_textController.text.trim().isEmpty || isAnimating)
                            ? null
                            : _handleTranslate,
                        icon: Icon(
                          isAnimating ? Icons.hourglass_top : Icons.send,
                          size: 18,
                        ),
                        label: Text(isAnimating ? 'Running...' : 'Translate'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Controls if Active
          if (_positions.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: _handlePause,
                  icon: Icon(_state == TranslationState.translating ? Icons.pause : Icons.play_arrow),
                ),
                const SizedBox(width: 16),
                IconButton.outlined(
                  onPressed: _handleClear,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Status and Display Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
              border: Border.all(
                color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFE2E8F0),
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: [
                StatusBar(
                  state: _state,
                  currentIndex: _currentIndex,
                  totalCharacters: _positions.length,
                ),
                const SizedBox(height: 24),

                // Live Large Preview
                if (_state != TranslationState.idle && _positions.isNotEmpty) ...[
                  Container(
                    height: 280,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode ? const Color(0xFF333333) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CustomPaint(
                            painter: SemaphoreManPainter(
                              leftAngle: _getCurrentPosition().leftAngle,
                              rightAngle: _getCurrentPosition().rightAngle,
                              isDarkMode: isDarkMode,
                              primaryColor: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Align(
                                alignment: _alignmentAnimation.value,
                                child: Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              _getCurrentPosition().character.toUpperCase(),
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                ],

                _buildFlagGrid(context),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  SemaphorePosition _getCurrentPosition() {
    if (_positions.isEmpty) return const SemaphorePosition(leftAngle: 0, rightAngle: 0, character: ' ');
    if (_currentIndex >= _positions.length) return const SemaphorePosition(leftAngle: 0, rightAngle: 0, character: ' '); // Return to rest
    return _positions[_currentIndex];
  }

  Widget _buildFlagGrid(BuildContext context) {
    final theme = Theme.of(context);

    if (_positions.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_circle_outlined,
              size: 80,
              color: theme.colorScheme.surfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Waiting for signals...',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: _positions.length,
      itemBuilder: (context, index) {
        return FlagDisplay(
          position: _positions[index],
          isActive: index <= _currentIndex,
          index: index,
        );
      },
    );
  }
}
