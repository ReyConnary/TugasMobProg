import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'home_page.dart';

void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatefulWidget {
  const InventoryApp({super.key});

  static _InventoryAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_InventoryAppState>();

  @override
  _InventoryAppState createState() => _InventoryAppState();
}

class _InventoryAppState extends State<InventoryApp> {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      themeMode =
          themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Barang',

      themeMode: themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[800],
      ),

      home: const HomePage(),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],
    );
  }
}
