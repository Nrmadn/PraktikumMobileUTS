import 'package:flutter/material.dart';

//  WARNA-WARNA APLIKASI

const primaryColor = Color(0xFF7B5BA4); // Ungu utama
const primaryColorDark = Color(0xFF6B4B94); // Ungu gelap
const secondaryColor = Color(0xFF9C7FB8); // Ungu muda
const accentColor = Color(0xFFFFC107); // Kuning/Gold

const backgroundColor = Color(0xFFF5F5F5); // Abu-abu sangat muda
const cardBackgroundColor = Color(0xFFFFFFFF); // Putih
const darkBackgroundColor = Color(0xFF1A1A1A); // Hitam (untuk dark mode)

const textColor = Color(0xFF333333); // Teks gelap
const textColorLight = Color(0xFF666666); // Teks lebih terang
const textColorLighter = Color(0xFF999999); // Teks paling terang
const textColorWhite = Color(0xFFFFFFFF); // Teks putih

const successColor = Color(0xFF4CAF50); // Hijau (berhasil)
const errorColor = Color(0xFFFF5252); // Merah (error)
const warningColor = Color(0xFFFFC107); // Kuning (warning)
const infoColor = Color(0xFF2196F3); // Biru (info)

const borderColor = Color(0xFFE0E0E0); // Border abu-abu
const dividerColor = Color(0xFFEEEEEE); // Divider abu-abu muda

//  STRING/TEKS APLIKASI

// App Name & General
const String appName = 'Target Ibadah Harian';
const String appDescription = 'Aplikasi Gamifikasi Target Ibadah Harian';

// Splash Screen
const String splashTitle = 'Target Ibadah Harian';
const String splashSubtitle = 'Motivasi Ibadah Setiap Hari';

// Login Screen
const String loginTitle = 'Masuk ke Akun Anda';
const String loginEmail = 'Email';
const String loginPassword = 'Password';
const String loginButton = 'Masuk';
const String forgotPassword = 'Lupa Password?';
const String noAccount = 'Belum punya akun? ';
const String registerNow = 'Daftar Sekarang';

// Register Screen
const String registerTitle = 'Buat Akun Baru';
const String registerFullName = 'Nama Lengkap';
const String registerEmail = 'Email';
const String registerPassword = 'Password';
const String registerConfirmPassword = 'Konfirmasi Password';
const String registerButton = 'Buat Akun';
const String alreadyHaveAccount = 'Sudah punya akun? ';
const String loginHere = 'Masuk di sini';

// Home Screen
const String greeting = 'Assalamu\'alaikum';
const String homeTitle = 'Dashboard';
const String prayerTimesLabel = 'Jadwal Sholat Hari Ini';
const String categoryLabel = 'Kategori';
const String progressLabel = 'Progress Ibadah Harian';
const String targetsLabel = 'Target Ibadah';
const String addTarget = 'Tambah Target';
const String nextPrayer = 'Sholat Berikutnya: ';
const String in_text = ' dalam ';
const String completedTargets = 'Kamu sudah menyelesaikan';
const String outOf = 'dari';
const String targets = 'target hari ini';

// Category
const String categoryPrayer = 'Sholat';
const String categoryQuran = 'Qur\'an';
const String categoryCharity = 'Sedekah';
const String categoryZikir = 'Dzikir';
const String categoryOther = 'Lainnya';

// Add/Edit Target Screen
const String addTargetTitle = 'Tambah Target Ibadah';
const String editTargetTitle = 'Edit Target Ibadah';
const String targetName = 'Nama Target';
const String targetCategory = 'Kategori';
const String targetNote = 'Catatan Tambahan';
const String saveButton = 'Simpan';
const String updateButton = 'Update';
const String cancelButton = 'Batal';

// Prayer Time Screen
const String prayerTimeTitle = 'Jadwal Sholat';
const String fajr = 'Subuh';
const String dhuhr = 'Dhuhur';
const String asr = 'Ashar';
const String maghrib = 'Maghrib';
const String isha = 'Isya';
const String refreshButton = 'Segarkan';

// Progress Screen
const String progressTitle = 'Progress & Statistik';
const String levelLabel = 'Level';
const String pointsLabel = 'Poin';
const String dailyProgress = 'Progress Harian';
const String weeklyProgress = 'Progress Mingguan';
const String motivationMessage = 'Terus semangat menjalankan ibadah! 💪';

// Profile Screen
const String profileTitle = 'Profil Saya';
const String profileName = 'Nama';
const String profileEmail = 'Email';
const String profileLevel = 'Level';
const String changePassword = 'Ubah Password';
const String editProfile = 'Edit Profil';
const String logoutButton = 'Keluar';
const String achievementLabel = 'Capaian Hari Ini';

// Setting Screen
const String settingTitle = 'Pengaturan';
const String themeLabel = 'Tema';
const String darkMode = 'Mode Gelap';
const String lightMode = 'Mode Terang';
const String languageLabel = 'Bahasa';
const String notificationLabel = 'Notifikasi';
const String prayerNotification = 'Notifikasi Waktu Sholat';
const String aboutApp = 'Tentang Aplikasi';

// Bottom Navigation
const String navHome = 'Beranda';
const String navSchedule = 'Progress';
const String navCalendar = 'Target';
const String navProfile = 'Profil';
const String navSetting = 'Pengaturan';

// Validation Messages
const String emptyEmailError = 'Email tidak boleh kosong';
const String invalidEmailError = 'Format email tidak valid';
const String emptyPasswordError = 'Password tidak boleh kosong';
const String passwordTooShortError = 'Password minimal 6 karakter';
const String emptyNameError = 'Nama tidak boleh kosong';
const String passwordMismatchError = 'Password tidak cocok';

// Success & Error Messages
const String loginSuccess = 'Login berhasil!';
const String loginFailed = 'Login gagal. Periksa kembali email dan password Anda.';
const String registerSuccess = 'Pendaftaran berhasil! Silakan login.';
const String registerFailed = 'Pendaftaran gagal. Email mungkin sudah terdaftar.';
const String targetAdded = 'Target berhasil ditambahkan!';
const String targetUpdated = 'Target berhasil diperbarui!';
const String targetDeleted = 'Target berhasil dihapus!';
const String passwordChanged = 'Password berhasil diubah!';
const String logoutConfirm = 'Apakah Anda yakin ingin keluar?';

// 📏 UKURAN & SPACING

// Font Sizes
const double fontSizeSmall = 12.0;
const double fontSizeNormal = 14.0;
const double fontSizeMedium = 16.0;
const double fontSizeLarge = 18.0;
const double fontSizeXLarge = 24.0;
const double fontSizeXXLarge = 32.0;

// Padding & Margin
const double paddingXSmall = 4.0;
const double paddingSmall = 8.0;
const double paddingNormal = 16.0;
const double paddingMedium = 24.0;
const double paddingLarge = 32.0;
const double paddingXLarge = 48.0;

// Border Radius
const double borderRadiusSmall = 4.0;
const double borderRadiusNormal = 8.0;
const double borderRadiusMedium = 12.0;
const double borderRadiusLarge = 16.0;
const double borderRadiusXLarge = 24.0;

// Icon Sizes
const double iconSizeSmall = 16.0;
const double iconSizeNormal = 24.0;
const double iconSizeMedium = 32.0;
const double iconSizeLarge = 48.0;

// Button Heights
const double buttonHeightSmall = 36.0;
const double buttonHeightNormal = 48.0;
const double buttonHeightLarge = 56.0;

// 🎨 THEME DATA

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: textColorWhite,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: textColorWhite,
      fontSize: fontSizeLarge,
      fontWeight: FontWeight.bold,
    ),
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: textColorWhite,
      padding: const EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusNormal),
      ),
      textStyle: const TextStyle(
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: primaryColor,
      side: const BorderSide(color: primaryColor),
      padding: const EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusNormal),
      ),
    ),
  ),
  
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: cardBackgroundColor,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: paddingMedium,
      vertical: paddingNormal,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusNormal),
      borderSide: const BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusNormal),
      borderSide: const BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadiusNormal),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    labelStyle: const TextStyle(color: textColorLight),
    hintStyle: const TextStyle(color: textColorLighter),
  ),
  
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: cardBackgroundColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: textColorLight,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
  
  cardTheme: CardTheme(
    color: cardBackgroundColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusNormal),
    ),
  ),
  
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: fontSizeXXLarge,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
    displayMedium: TextStyle(
      fontSize: fontSizeXLarge,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
    displaySmall: TextStyle(
      fontSize: fontSizeLarge,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
    headlineMedium: TextStyle(
      fontSize: fontSizeLarge,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    bodyLarge: TextStyle(
      fontSize: fontSizeMedium,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    bodyMedium: TextStyle(
      fontSize: fontSizeNormal,
      fontWeight: FontWeight.w400,
      color: textColor,
    ),
    bodySmall: TextStyle(
      fontSize: fontSizeSmall,
      fontWeight: FontWeight.w400,
      color: textColorLight,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: darkBackgroundColor,
  
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColorDark,
    foregroundColor: textColorWhite,
    elevation: 0,
    centerTitle: true,
  ),
  
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: textColorWhite,
    ),
  ),
);