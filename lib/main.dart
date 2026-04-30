import 'package:flutter/material.dart';
import 'screens/cadastro_screen.dart';

// Notificador global para controlar o modo do tema
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'App Cadastro',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode, // Controla qual tema usar
          // TEMA CLARO
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6750A4),
              brightness: Brightness.light,
              // ignore: deprecated_member_use
              background: const Color(0xFFF4F4F9),
            ),
            inputDecorationTheme: _buildInputTheme(Brightness.light),
          ),

          // TEMA ESCURO
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFD0BCFF),
              brightness: Brightness.dark,
            ),
            inputDecorationTheme: _buildInputTheme(Brightness.dark),
          ),

          home: CadastroScreen(),
        );
      },
    );
  }

  InputDecorationTheme _buildInputTheme(Brightness brightness) {
    bool isDark = brightness == Brightness.dark;
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? Colors.grey.shade900 : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFFD0BCFF) : const Color(0xFF6750A4),
          width: 2,
        ),
      ),
    );
  }
}
