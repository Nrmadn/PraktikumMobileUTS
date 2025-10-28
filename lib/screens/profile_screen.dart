import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/bottom_navigation.dart';

// Halaman menampilkan data profil pengguna dari SharedPreferences

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //  VARIABLES
  int selectedNavIndex = 3; // Profile
  bool isLoading = true;

  // Data user yang akan diisi dari SharedPreferences
  String userName = 'User';
  String userEmail = 'user@example.com';
  int userLevel = 1;
  int userPoints = 0;
  int completedTargetsToday = 0;
  int totalTargetsToday = 7;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  //  LOAD USER DATA dari SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      setState(() {
        userName = prefs.getString('userName') ?? 'User';
        userEmail = prefs.getString('userEmail') ?? 'user@example.com';
        userLevel = prefs.getInt('userLevel') ?? 1;
        userPoints = prefs.getInt('userPoints') ?? 0;
        completedTargetsToday = prefs.getInt('completedTargetsToday') ?? 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
        break;
      case 4: // Setting
        Navigator.pushNamed(context, '/setting');
        break;
    }
  }

  //  HANDLE LOGOUT
  void handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text(logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Hapus data user dari SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              await prefs.remove('userEmail');
              await prefs.remove('userName');
              await prefs.remove('userLevel');
              await prefs.remove('userPoints');

              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anda berhasil keluar'),
                  backgroundColor: successColor,
                  duration: Duration(seconds: 2),
                ),
              );
              
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Keluar', style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(title: const Text(profileTitle)),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(profileTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //  PROFILE HEADER
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColorDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: paddingLarge),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: textColorWhite,
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: textColorWhite,
                        size: 50,
                      ),
                    ),

                    const SizedBox(height: paddingMedium),

                    // Nama
                    Text(
                      userName,
                      style: const TextStyle(
                        color: textColorWhite,
                        fontSize: fontSizeXLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: paddingSmall),

                    // Email
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: textColorWhite,
                        fontSize: fontSizeNormal,
                      ),
                    ),

                    const SizedBox(height: paddingMedium),

                    // Level Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: paddingMedium,
                        vertical: paddingSmall,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(borderRadiusLarge),
                        border: Border.all(
                          color: textColorWhite,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Level $userLevel • $userPoints Poin',
                        style: const TextStyle(
                          color: textColorWhite,
                          fontSize: fontSizeNormal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: paddingLarge),

              //  ACHIEVEMENT SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      achievementLabel,
                      style: TextStyle(
                        fontSize: fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: paddingNormal),
                    Container(
                      padding: const EdgeInsets.all(paddingMedium),
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(borderRadiusNormal),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$completedTargetsToday dari $totalTargetsToday target selesai hari ini',
                            style: const TextStyle(
                              fontSize: fontSizeMedium,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: paddingNormal),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value:
                                  completedTargetsToday / totalTargetsToday,
                              minHeight: 12,
                              backgroundColor: dividerColor,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                successColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: paddingNormal),
                          const Text(
                            '🎉 Selamat! Anda sudah sangat konsisten dalam menjalankan ibadah.',
                            style: TextStyle(
                              fontSize: fontSizeSmall,
                              color: textColorLight,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: paddingLarge),

              // PROFILE OPTIONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pengaturan Profil',
                      style: TextStyle(
                        fontSize: fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: paddingNormal),
                    // Edit Profile
                    _buildProfileOption(
                      icon: Icons.edit,
                      title: editProfile,
                      subtitle: 'Ubah data pribadi Anda',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur edit profil akan segera tersedia'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: paddingNormal),
                    // Change Password
                    _buildProfileOption(
                      icon: Icons.lock,
                      title: changePassword,
                      subtitle: 'Ubah password akun Anda',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fitur ubah password akan segera tersedia'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: paddingLarge),

              //  ACTION BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Column(
                  children: [
                    CustomButton(
                      text: logoutButton,
                      onPressed: handleLogout,
                      backgroundColor: errorColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: paddingLarge),

              // APP INFO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontSize: fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: paddingNormal),
                    Container(
                      padding: const EdgeInsets.all(paddingMedium),
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(borderRadiusNormal),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appName,
                            style: TextStyle(
                              fontSize: fontSizeMedium,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: paddingSmall),
                          Text(
                            'Versi 1.0.0',
                            style: TextStyle(
                              fontSize: fontSizeNormal,
                              color: textColorLight,
                            ),
                          ),
                          SizedBox(height: paddingSmall),
                          Text(
                            appDescription,
                            style: TextStyle(
                              fontSize: fontSizeSmall,
                              color: textColorLight,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: paddingLarge),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigation(
        currentIndex: selectedNavIndex,
        onTap: handleNavigation,
      ),
    );
  }

  //  HELPER WIDGET - PROFILE OPTION
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(paddingMedium),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadiusNormal),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(borderRadiusNormal),
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: iconSizeNormal,
              ),
            ),
            const SizedBox(width: paddingMedium),
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
            const Icon(
              Icons.arrow_forward_ios,
              color: textColorLight,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}