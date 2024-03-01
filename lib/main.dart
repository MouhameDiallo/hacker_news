import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'App.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: const App(),
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        color: Colors.blueAccent,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
        // ···
        titleLarge: GoogleFonts.oswald(
          fontSize: 30,
          fontStyle: FontStyle.italic,
        ),
        bodyLarge: GoogleFonts.merriweather(),
        bodyMedium: GoogleFonts.lato(),
        displaySmall: GoogleFonts.pacifico(),
      ),
      scaffoldBackgroundColor: Colors.blue[50],

      useMaterial3: true,),
  ));
}
