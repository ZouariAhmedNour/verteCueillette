import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertecueilletteapp/router/app_router.dart';
import 'package:vertecueilletteapp/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: VerteCueilletteApp()));
}

class VerteCueilletteApp extends ConsumerWidget {
  const VerteCueilletteApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Verte Cueillette',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      );
  }
}


