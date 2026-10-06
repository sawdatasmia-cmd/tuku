import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screen/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TukuApp());
}

class TukuApp extends StatelessWidget {
  const TukuApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBrown = Color(0xFF410200);
    const mainText = Color(0xFF2B211D);
    const secondaryText = Color(0xFF72554D);
    const cream = Color(0xFFFFF8ED);
    const surface = Color(0xFFFFFDF8);
    const border = Color(0xFFE9DCCB);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tuku!!',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBrown,
          brightness: Brightness.light,
        ).copyWith(
          primary: primaryBrown,
          onPrimary: Colors.white,
          surface: surface,
          onSurface: mainText,
        ),

        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: mainText,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: mainText,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: mainText,
          ),
          bodyMedium: TextStyle(
            color: secondaryText,
          ),
          labelLarge: TextStyle(
            color: mainText,
            fontWeight: FontWeight.w600,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: border,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: border,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: primaryBrown,
              width: 1.8,
            ),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFB94A48),
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFB94A48),
              width: 1.8,
            ),
          ),

          labelStyle: const TextStyle(
            color: secondaryText,
          ),

          prefixIconColor: secondaryText,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBrown,
            foregroundColor: Colors.white,

            minimumSize: const Size(
              double.infinity,
              52,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            elevation: 0,

            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryBrown,

            minimumSize: const Size(
              double.infinity,
              52,
            ),

            side: const BorderSide(
              color: primaryBrown,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),

      home: const LoginScreen(),
    );
  }
}