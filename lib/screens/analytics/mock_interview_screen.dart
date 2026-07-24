import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';

class MockInterviewScreen extends ConsumerStatefulWidget {
  const MockInterviewScreen({super.key});
  @override
  ConsumerState<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends ConsumerState<MockInterviewScreen> {
  final List<Map<String, dynamic>> _questions = [
    {
      'q': 'What is the time complexity of searching in a Balanced Binary Search Tree?',
      'options': ['O(1)', 'O(n)', 'O(log n)', 'O(n log n)'],
      'correct': 2,
      'explanation': 'In a balanced BST, each comparison skips half the remaining tree, resulting in logarithmic time complexity.',
    },
    {
      'q': 'Which of the following is NOT an ACID property in DBMS?',
      'options': ['Atomicity', 'Consistency', 'Integrity', 'Durability'],
      'correct': 2,
      'explanation': 'ACID stands for Atomicity, Consistency, Isolation, and Durability. Integrity is not one of them.',
    },
    {
      'q': 'What is the purpose of "volatile" keyword in Java?',
      'options': ['Memory management', 'Thread synchronization', 'Visibility across threads', 'Serialization'],
      'correct': 2,
      'explanation': 'The volatile keyword ensures that the value of the variable is always read from and written to the main memory, not from the thread\'s local cache.',
    },
  ];

  int _currentIndex = 0;
  int? _selectedOption;
  bool _showFeedback = false;
  int _score = 0;

  void _next() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _showFeedback = false;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Interview Completed!'),
        content: Text('Your score: $_score / ${_questions.length}'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit interview
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('AI Mock Interview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 32),
            Text('Question ${_currentIndex + 1} of ${_questions.length}', 
                style: GoogleFonts.inter(fontSize: 14, color: isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight)),
            const SizedBox(height: 12),
            Text(q['q'], style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight)),
            const SizedBox(height: 32),
            ...List.generate(q['options'].length, (i) {
              final isSelected = _selectedOption == i;
              Color borderColor = isDark ? AppTheme.borderDark : AppTheme.borderLight;
              Color bgColor = Colors.transparent;

              if (_showFeedback) {
                if (i == q['correct']) {
                  borderColor = AppTheme.accentGreen;
                  bgColor = AppTheme.accentGreen.withValues(alpha: 0.1);
                } else if (isSelected) {
                  borderColor = AppTheme.accentRed;
                  bgColor = AppTheme.accentRed.withValues(alpha: 0.1);
                }
              } else if (isSelected) {
                borderColor = AppTheme.primaryBlue;
                bgColor = AppTheme.primaryBlue.withValues(alpha: 0.05);
              }

              return GestureDetector(
                onTap: _showFeedback ? null : () => setState(() => _selectedOption = i),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24, height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: isSelected ? AppTheme.primaryBlue : (isDark ? Colors.white24 : Colors.grey)),
                        ),
                        child: isSelected ? const Center(child: Icon(Icons.check, size: 14, color: AppTheme.primaryBlue)) : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Text(q['options'][i], style: GoogleFonts.inter(fontSize: 15))),
                    ],
                  ),
                ),
              );
            }),
            const Spacer(),
            if (_showFeedback)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (_selectedOption == q['correct'] ? AppTheme.accentGreen : AppTheme.accentAmber).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: (_selectedOption == q['correct'] ? AppTheme.accentGreen : AppTheme.accentAmber).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_selectedOption == q['correct'] ? '✅ Correct!' : '❌ Incorrect', 
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: _selectedOption == q['correct'] ? AppTheme.accentGreen : AppTheme.accentRed)),
                    const SizedBox(height: 4),
                    Text(q['explanation'], style: GoogleFonts.inter(fontSize: 13)),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: _selectedOption == null ? null : (_showFeedback ? _next : () {
                  setState(() {
                    _showFeedback = true;
                    if (_selectedOption == q['correct']) _score++;
                  });
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(_showFeedback ? 'Continue' : 'Submit Answer', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
