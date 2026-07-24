import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_insight_ai/core/theme/app_theme.dart';
import 'package:student_insight_ai/providers/providers.dart';
import 'package:student_insight_ai/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization would go here when ready:
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const ProviderScope(child: StudentInsightApp()));
}

class StudentInsightApp extends ConsumerWidget {
  const StudentInsightApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Wait for auth init before showing main app routes
    final init = ref.watch(initializationProvider);
    final router = ref.watch(routerProvider);
    final isDark = ref.watch(themeProvider);

    return init.when(
      loading: () => const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))),
      error: (err, stack) => MaterialApp(home: Scaffold(body: Center(child: Text('Error initializing app: $err')))),
      data: (_) {
        return MaterialApp.router(
          title: 'StudentInsight AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
        );
      },
    );
  }
}
