import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/bottom_navigation.dart';

// SETTING SCREEN
// Halaman untuk pengaturan aplikasi
// Menampilkan: Tema, Notifikasi, Bahasa, Tentang Aplikasi

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // VARIABLES
  int selectedNavIndex = 4; // Setting
  
  // Setting values
  bool darkModeEnabled = false;
  bool prayerNotificationEnabled = true;
  bool motivationNotificationEnabled = true;
  String selectedLanguage = 'Bahasa Indonesia';

  //  HANDLE NAVIGATION
  void handleNavigation(int index) {
    setState(() {
      selectedNavIndex = index;
    });

    switch (index) {
      case 0: // Home
        Navigator.pushNamed(context, '/home');
        break;
      case 1: // Calendar
        Navigator.pushNamed(context, '/progress');
        break;
      case 2: // Schedule
        Navigator.pushNamed(context, '/progress_home');
        break;
      case 3: // Profile
        Navigator.pushNamed(context, '/profile');
        break;
      case 4: // Setting
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(settingTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // APPEARANCE SECTION
                _buildSectionTitle('Tampilan'),
                const SizedBox(height: paddingNormal),
                
                // Dark Mode
                _buildSettingItem(
                  title: 'Mode Gelap',
                  subtitle: 'Aktifkan mode gelap untuk mengurangi kelelahan mata',
                  trailing: Switch(
                    value: darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        darkModeEnabled = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value
                              ? 'Mode gelap diaktifkan'
                              : 'Mode terang diaktifkan'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    activeColor: primaryColor,
                  ),
                ),

                const SizedBox(height: paddingLarge),

                //  NOTIFICATION SECTION
                _buildSectionTitle(notificationLabel),
                const SizedBox(height: paddingNormal),

                // Prayer Time Notification
                _buildSettingItem(
                  title: prayerNotification,
                  subtitle: 'Dapatkan notifikasi saat waktu sholat tiba',
                  trailing: Switch(
                    value: prayerNotificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        prayerNotificationEnabled = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value
                              ? 'Notifikasi sholat diaktifkan'
                              : 'Notifikasi sholat dinonaktifkan'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    activeColor: primaryColor,
                  ),
                ),

                const SizedBox(height: paddingNormal),

                // Motivation Notification
                _buildSettingItem(
                  title: 'Notifikasi Motivasi',
                  subtitle: 'Dapatkan pesan motivasi setiap pagi',
                  trailing: Switch(
                    value: motivationNotificationEnabled,
                    onChanged: (value) {
                      setState(() {
                        motivationNotificationEnabled = value;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(value
                              ? 'Notifikasi motivasi diaktifkan'
                              : 'Notifikasi motivasi dinonaktifkan'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    activeColor: primaryColor,
                  ),
                ),

                const SizedBox(height: paddingLarge),

                //  LANGUAGE SECTION
                _buildSectionTitle(languageLabel),
                const SizedBox(height: paddingNormal),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: paddingMedium,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedLanguage,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Bahasa Indonesia',
                        child: Text('Bahasa Indonesia'),
                      ),
                      DropdownMenuItem(
                        value: 'English',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'العربية',
                        child: Text('العربية'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLanguage = newValue ?? 'Bahasa Indonesia';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bahasa diubah menjadi $selectedLanguage'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: paddingLarge),

                //  ABOUT SECTION
                _buildSectionTitle('Tentang'),
                const SizedBox(height: paddingNormal),

                // App Version
                _buildSettingItem(
                  title: 'Versi Aplikasi',
                  subtitle: '1.0.0',
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: textColorLight,
                    size: 16,
                  ),
                ),

                const SizedBox(height: paddingNormal),

                // Terms & Privacy
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Syarat & Ketentuan akan segera tersedia'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: _buildSettingItem(
                    title: 'Syarat & Ketentuan',
                    subtitle: 'Baca syarat layanan kami',
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: textColorLight,
                      size: 16,
                    ),
                  ),
                ),

                const SizedBox(height: paddingNormal),

                // Privacy Policy
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Kebijakan Privasi akan segera tersedia'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: _buildSettingItem(
                    title: 'Kebijakan Privasi',
                    subtitle: 'Baca kebijakan privasi kami',
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: textColorLight,
                      size: 16,
                    ),
                  ),
                ),

                const SizedBox(height: paddingLarge),

                // INFO BOX
                Container(
                  padding: const EdgeInsets.all(paddingMedium),
                  decoration: BoxDecoration(
                    color: infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                    border: Border.all(color: infoColor),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Tips:',
                        style: TextStyle(
                          fontSize: fontSizeNormal,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: paddingSmall),
                      Text(
                        'Pastikan notifikasi diaktifkan agar Anda tidak melewatkan waktu sholat dan pesan motivasi setiap hari.',
                        style: TextStyle(
                          fontSize: fontSizeSmall,
                          color: textColorLight,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: paddingLarge),

                //  BUILD INFO
                Container(
                  padding: const EdgeInsets.all(paddingMedium),
                  decoration: BoxDecoration(
                    color: dividerColor,
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Text(
                          appName,
                          style: TextStyle(
                            fontSize: fontSizeNormal,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Build 001 • © 2025',
                          style: TextStyle(
                            fontSize: fontSizeSmall,
                            color: textColorLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: paddingLarge),
              ],
            ),
          ),
        ),
      ),

      //  BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigation(
        currentIndex: selectedNavIndex,
        onTap: handleNavigation,
      ),
    );
  }

  //  HELPER WIDGETS

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: fontSizeLarge,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(paddingMedium),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadiusNormal),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: fontSizeNormal,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: fontSizeSmall,
                    color: textColorLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: paddingMedium),
          trailing,
        ],
      ),
    );
  }
}

