import 'package:flutter/material.dart';
import 'src/spring_surface_playground.dart';
import 'src/spring_surface_test_lab_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
      ),
      routes: {
        SpringSurfaceTestLabPage.routeName: (_) =>
            const SpringSurfaceTestLabPage(),
      },
      home: const SpringSurfacePlayground(),
    );
  }
}
