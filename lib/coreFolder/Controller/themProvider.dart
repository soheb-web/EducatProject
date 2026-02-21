// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// // final themeProvider = StateProvider<ThemeMode>((ref) {
// //   return ThemeMode.light; // default
// // });

// class ThemeNotifier extends StateNotifier<ThemeMode> {
//   ThemeNotifier() : super(ThemeMode.light);

//   void toggleTheme() {
//     state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
//   }

//   void setTheme(ThemeMode mode) {
//     state = mode;
//   }
// }

// final themeProvider =
//     StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

// class AppTheme {
//   static final lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: Color(0xff9088F1),
//     scaffoldBackgroundColor: Colors.white,
//     appBarTheme: AppBarTheme(
//       backgroundColor: Color(0xff9088F1),
//       foregroundColor: Colors.white,
//     ),
//   );

//   static final darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: Color(0xff00b3b3),
//     scaffoldBackgroundColor: Color(0xFF1B1B1B),
//     appBarTheme: AppBarTheme(
//       backgroundColor: Color(0xFF1B1B1B),
//       foregroundColor: Colors.white,
//     ),
//   );
// }
