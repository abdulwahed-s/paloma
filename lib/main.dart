import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paloma/core/routes/page_router.dart';
import 'package:paloma/data/repository/auth_repository.dart';
import 'package:paloma/firebase_options.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthRepository());
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Paloma',

      theme: FlexThemeData.light(
        scheme: FlexScheme.mandyRed,
        useMaterial3: true,
      ),

      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.mandyRed,
        useMaterial3: true,
      ),

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      debugShowCheckedModeBanner: false,
      onGenerateRoute: PageRouter().generateRoute,
    );
  }
}
