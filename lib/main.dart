import 'package:odev_3/widgets/dizilerim.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//mport 'package:flutter/services.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.limeAccent);
var kDarkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 42, 45, 9),
    brightness: Brightness.dark);

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) {
  runApp(const MainApp());
  //});
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
      ],
      darkTheme: ThemeData.dark().copyWith(colorScheme: kDarkColorScheme),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(color: kColorScheme.onSecondaryContainer),
              titleMedium: TextStyle(
                color: kColorScheme.onTertiaryContainer,
                fontSize: 18,
              ),
              titleSmall: TextStyle(
                color: kColorScheme.primaryContainer,
                fontSize: 14,
              ),
            ),
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const Dizilerim(),
    );
  }
}
