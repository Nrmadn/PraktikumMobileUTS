import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/target_ibadah_model.dart';
import '../services/json_service.dart';
import '../widgets/bottom_navigation.dart';

// UPDATE: Load data dari JSON, checkbox disabled (READ only)

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //  VARIABLES
  int selectedNavIndex = 0;
  String userName = 'User';
  bool isLoadingUser = true;
  bool isLoadingData = true;

  // Data dari JSON
  Map<String, String> prayerTimes = {};
  List<TargetIbadah> targets = [];
  List<Map<String, dynamic>> categories = [];
  Map<String, String> nextPrayerInfo = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadJsonData();
  }

  // LOAD USER DATA dari SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userName = prefs.getString('userName') ?? 'User';
        isLoadingUser = false;
      });
    } catch (e) {
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  // LOAD DATA dari JSON
  Future<void> _loadJsonData() async {
    try {
      // Load semua data parallel
      final results = await Future.wait([
        JsonService.getPrayerTimesMap(),
        JsonService.getTodayTargets(),
        JsonService.getCategoriesList(),
        JsonService.getNextPrayerInfo(),
      ]);

      setState(() {
        prayerTimes = results[0] as Map<String, String>;
        targets = results[1] as List<TargetIbadah>;
        categories = results[2] as List<Map<String, dynamic>>;
        nextPrayerInfo = results[3] as Map<String, String>;
        isLoadingData = false;
      });
    } catch (e) {
      print('Error loading JSON data: $e');
      setState(() {
        isLoadingData = false;
      });
    }
  }

  // HELPER FUNCTION - Hitung progress
  int getCompletedTargetsCount() {
    return targets.where((target) => target.isCompleted).length;
  }

  int getTodayTargetsCount() {
    return targets.length;
  }

  double getProgressPercentage() {
    final todayTargets = getTodayTargetsCount();
    if (todayTargets == 0) return 0;
    return (getCompletedTargetsCount() / todayTargets) * 100;
  }

  // HANDLE NAVIGATION
  void handleNavigation(int index) {
    setState(() {
      selectedNavIndex = index;
    });

    switch (index) {
      case 0: // Home
        break;
      case 1: // Calendar/Progress
        Navigator.pushNamed(context, '/progress');
        break;
      case 2: // Manajemen Target
        Navigator.pushNamed(context, '/progress_home');
        break;
      case 3: // Profile
        Navigator.pushNamed(context, '/profile');
        break;
      case 4: // Setting
        Navigator.pushNamed(context, '/setting');
        break;
    }
  }

  // HANDLE CATEGORY NAVIGATION
  void handleCategoryTap(String categoryName) {
    if (categoryName == categoryPrayer) {
      Navigator.pushNamed(context, '/sholat');
    } else if (categoryName == categoryQuran) {
      Navigator.pushNamed(context, '/quran');
    } else if (categoryName == categoryZikir) {
      Navigator.pushNamed(context, '/dzikir');
    } else if (categoryName == categoryCharity) {
      Navigator.pushNamed(context, '/sedekah');
    }
  }

  // HANDLE CHECKBOX - DISABLED (READ ONLY)
  void handleCheckboxChange(String targetId, bool isChecked) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur ini akan tersedia di versi lengkap'),
        backgroundColor: warningColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // GET COLOR from HEX string
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  // GET ICON from string name
  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'mosque':
        return Icons.mosque;
      case 'menu_book':
        return Icons.menu_book;
      case 'favorite':
        return Icons.favorite;
      case 'favorite_border':
        return Icons.favorite_border;
      default:
        return Icons.task_alt;
    }
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = getCompletedTargetsCount();
    int todayCount = getTodayTargetsCount();
    double progress = getProgressPercentage();

    // Loading state
    if (isLoadingData) {
      return const Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GREETING SECTION
              Padding(
                padding: const EdgeInsets.all(paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoadingUser ? 'Halo 👋' : '$greeting, $userName 👋',
                      style: const TextStyle(
                        fontSize: fontSizeXLarge,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: paddingSmall),
                    Text(
                      _getFormattedDate(DateTime.now()),
                      style: const TextStyle(
                        fontSize: fontSizeNormal,
                        color: textColorLight,
                      ),
                    ),
                  ],
                ),
              ),

              // PRAYER TIMES CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryColor, primaryColorDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(borderRadiusNormal),
                    ),
                    padding: const EdgeInsets.all(paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          prayerTimesLabel,
                          style: TextStyle(
                            color: textColorWhite,
                            fontSize: fontSizeLarge,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: paddingNormal),
                        prayerTimes.isEmpty
                            ? const Center(
                                child: Text(
                                  'Jadwal sholat tidak tersedia',
                                  style: TextStyle(color: textColorWhite),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: prayerTimes.entries.map((entry) {
                                  return Column(
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(
                                          color: textColorWhite,
                                          fontSize: fontSizeSmall,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        entry.value,
                                        style: const TextStyle(
                                          color: textColorWhite,
                                          fontSize: fontSizeMedium,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                        const SizedBox(height: paddingMedium),
                        if (nextPrayerInfo.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(paddingSmall),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(borderRadiusSmall),
                            ),
                            child: Text(
                              'Sholat Berikutnya: ${nextPrayerInfo['name']} dalam ${nextPrayerInfo['countdown']} ⏰',
                              style: const TextStyle(
                                color: textColorWhite,
                                fontSize: fontSizeSmall,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: paddingMedium),

              // PROGRESS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress Hari Ini',
                          style: TextStyle(
                            fontSize: fontSizeLarge,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/progress');
                          },
                          child: const Text(
                            'Lihat Detail',
                            style: TextStyle(
                              fontSize: fontSizeSmall,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 12,
                              backgroundColor: dividerColor,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress >= 75
                                    ? successColor
                                    : progress >= 50
                                        ? accentColor
                                        : errorColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: paddingNormal),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$completedCount dari $todayCount target selesai',
                                style: const TextStyle(
                                  fontSize: fontSizeMedium,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: paddingSmall,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: progress >= 75
                                      ? successColor.withOpacity(0.1)
                                      : progress >= 50
                                          ? accentColor.withOpacity(0.1)
                                          : errorColor.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(borderRadiusSmall),
                                ),
                                child: Text(
                                  '${progress.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: fontSizeMedium,
                                    fontWeight: FontWeight.bold,
                                    color: progress >= 75
                                        ? successColor
                                        : progress >= 50
                                            ? accentColor
                                            : errorColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (progress == 100)
                            Padding(
                              padding: const EdgeInsets.only(top: paddingSmall),
                              child: Container(
                                padding: const EdgeInsets.all(paddingSmall),
                                decoration: BoxDecoration(
                                  color: successColor.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(borderRadiusSmall),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.celebration,
                                        color: successColor, size: 16),
                                    SizedBox(width: paddingSmall),
                                    Expanded(
                                      child: Text(
                                        'Luar biasa! Semua target hari ini selesai! 🎉',
                                        style: TextStyle(
                                          fontSize: fontSizeSmall,
                                          color: successColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: paddingMedium),

              // CATEGORY SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      categoryLabel,
                      style: TextStyle(
                        fontSize: fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: paddingNormal),
                    categories.isEmpty
                        ? const Text('Kategori tidak tersedia')
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: categories.map((category) {
                                final color = _getColorFromHex(
                                    category['color'].toString());
                                final icon = _getIconFromName(
                                    category['icon'].toString());

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: paddingNormal),
                                  child: GestureDetector(
                                    onTap: () {
                                      handleCategoryTap(
                                          category['name'].toString());
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(
                                                borderRadiusNormal),
                                            boxShadow: [
                                              BoxShadow(
                                                color: color.withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            icon,
                                            color: textColorWhite,
                                            size: iconSizeNormal,
                                          ),
                                        ),
                                        const SizedBox(height: paddingSmall),
                                        Text(
                                          category['name'].toString(),
                                          style: const TextStyle(
                                            fontSize: fontSizeSmall,
                                            fontWeight: FontWeight.w600,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: paddingMedium),

              // TARGET LIST SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Target Hari Ini',
                          style: TextStyle(
                            fontSize: fontSizeLarge,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/progress_home');
                          },
                          child: const Text(
                            'Kelola Target',
                            style: TextStyle(
                              fontSize: fontSizeSmall,
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: paddingNormal),
                    targets.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: paddingLarge),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.task_alt,
                                    size: 48,
                                    color: textColorLighter,
                                  ),
                                  const SizedBox(height: paddingNormal),
                                  const Text(
                                    'Tidak ada target untuk hari ini',
                                    style: TextStyle(
                                      fontSize: fontSizeNormal,
                                      color: textColorLight,
                                    ),
                                  ),
                                  const SizedBox(height: paddingSmall),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/progress_home');
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Tambah Target'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: targets.map((target) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: paddingNormal),
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        borderRadiusNormal),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(paddingMedium),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: target.isCompleted,
                                          onChanged: (value) {
                                            handleCheckboxChange(
                                                target.id, value ?? false);
                                          },
                                          activeColor: successColor,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                target.name,
                                                style: TextStyle(
                                                  fontSize: fontSizeMedium,
                                                  fontWeight: FontWeight.w600,
                                                  decoration:
                                                      target.isCompleted
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                  color: target.isCompleted
                                                      ? textColorLight
                                                      : textColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: paddingSmall),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: paddingSmall,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          borderRadiusSmall),
                                                ),
                                                child: Text(
                                                  target.category,
                                                  style: const TextStyle(
                                                    color: textColorWhite,
                                                    fontSize: fontSizeSmall,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              if (target.note.isNotEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: paddingSmall),
                                                  child: Text(
                                                    target.note,
                                                    style: const TextStyle(
                                                      fontSize: fontSizeSmall,
                                                      color: textColorLight,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
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

  // HELPER - Format Tanggal
  String _getFormattedDate(DateTime date) {
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}