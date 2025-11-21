import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wish_list_tier/data/providers.dart';
import 'package:wish_list_tier/data/repositories/firebase_wish_list_repository.dart';
import 'package:wish_list_tier/presentation/screens/tier_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    // Initialize Firebase repository (sign in anonymously and migrate data)
    final repository = ref.read(wishListRepositoryProvider);
    if (repository is FirebaseWishListRepository) {
      await repository.initialize();
    }
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: const Color(0xFFFFB7B2)),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Tierリスト',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB7B2),
          primary: const Color(0xFFFFB7B2),
          secondary: const Color(0xFFB5EAD7),
          surface: const Color(0xFFFFF9F9),
        ),
        textTheme: GoogleFonts.mPlusRounded1cTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFFFFB7B2),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.mPlusRounded1c(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFB7B2),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const TierListScreen(),
    );
  }
}
