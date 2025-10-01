import 'package:flutter/material.dart';
import 'screens/football_splash_screen.dart';

void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the dark color scheme
    const Color darkGrey = Color(0xFF121212); // Almost black
    const Color cardGrey = Color(0xFF1E1E1E); // Dark grey for cards
    
    return MaterialApp(
      title: 'fot mob',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use dark theme
        brightness: Brightness.dark,
        useMaterial3: false, // Disable Material 3 to avoid CardTheme issues
        
        // Set the scaffold background color to dark grey
        scaffoldBackgroundColor: darkGrey,
        
        // Define the color scheme
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
          surface: cardGrey,
          background: darkGrey,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        
        // Card theme with grey color
        cardTheme: CardThemeData(
          color: cardGrey,
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        
        // App bar theme
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Text theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      home: const FootballSplashScreen(),
    );
  }
}
