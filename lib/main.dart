import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_target_screen.dart';
import 'screens/edit_target_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/progress_home_screen.dart';
import 'screens/sholat_screen.dart';
import 'screens/quran_screen.dart';
import 'screens/sedekah_screen.dart';
import 'screens/dzikir_screen.dart';

//Ini adalah file utama yang menjalankan aplikasi
// Sekarang dengan check login status menggunakan SharedPreferences

void main() async {
  //  INITIALIZE FLUTTER BINDING
  // Pastikan Flutter sudah siap sebelum menggunakan plugins
  WidgetsFlutterBinding.ensureInitialized();

  //  CHECK LOGIN STATUS
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Jalankan aplikasi dengan status login
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    required this.isLoggedIn,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      // KONFIGURASI DASAR
      title: appName,
      debugShowCheckedModeBanner: false,

      //  THEME APLIKASI
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,

      // HALAMAN PERTAMA YANG DITAMPILKAN
      // Jika sudah login → ke Home Screen
      // Jika belum login → ke Splash Screen
      home: isLoggedIn ? const HomeScreen() : const SplashScreen(),

      //  ROUTING / NAVIGATION
      // Named routes untuk navigation antar halaman
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_target': (context) => const AddTargetScreen(),
        '/edit_target': (context) => const EditTargetScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/setting': (context) => const SettingScreen(),
        '/progress_home': (context) => const ProgressHomeScreen(),
        '/sholat': (context) => const SholatScreen(),
        '/quran': (context) => const QuranScreen(),
        '/dzikir': (context) => const DzikirScreen(),
        '/sedekah': (context) => const SedekahScreen(),
      },

      //  CUSTOM ROUTE HANDLER
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) =>
                  isLoggedIn ? const HomeScreen() : const SplashScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) =>
                  isLoggedIn ? const HomeScreen() : const SplashScreen(),
            );
        }
      },
    );
  }
}

