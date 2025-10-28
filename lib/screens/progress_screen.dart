import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../services/json_service.dart';
import '../widgets/bottom_navigation.dart';

// UPDATE: Load data dari JSON (progress stats, achievements, streak)

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // VARIABLES
  int selectedNavIndex = 1;
  int currentLevel = 3;
  int totalPoints = 2450;
  int pointsForNextLevel = 3000;
  bool isLoading = true;

  // Data dari JSON
  List<Map<String, dynamic>> dailyProgress = [];
  List<Map<String, dynamic>> categoryStats = [];
  List<Map<String, dynamic>> achievements = [];
  Map<String, dynamic> streakInfo = {};
  String motivationalMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserStats();
    _loadJsonData();
  }

  // LOAD USER STATS dari SharedPreferences
  Future<void> _loadUserStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentLevel = prefs.getInt('userLevel') ?? 3;
      totalPoints = prefs.getInt('userPoints') ?? 2450;
    });
  }

  // LOAD DATA dari JSON
  Future<void> _loadJsonData() async {
    try {
      final results = await Future.wait([
        JsonService.getDailyProgress(),
        JsonService.getCategoryStats(),
        JsonService.getAchievementsList(),
        JsonService.getStreakInfo(),
        JsonService.getMotivationalMessage(),
      ]);

      setState(() {
        dailyProgress = results[0] as List<Map<String, dynamic>>;
        categoryStats = results[1] as List<Map<String, dynamic>>;
        achievements = results[2] as List<Map<String, dynamic>>;
        streakInfo = results[3] as Map<String, dynamic>;
        motivationalMessage = results[4] as String;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading JSON data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // HANDLE NAVIGATION
  void handleNavigation(int index) {
    setState(() {
      selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushNamed(context, '/prayer_time');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
      case 4:
        Navigator.pushNamed(context, '/setting');
        break;
    }
  }

  // CALCULATE PROGRESS TO NEXT LEVEL
  double getProgressToNextLevel() {
    return totalPoints / pointsForNextLevel;
  }

  int getPointsNeeded() {
    return pointsForNextLevel - totalPoints;
  }

  // GET WEEKLY AVERAGE
  double getWeeklyAverage() {
    if (dailyProgress.isEmpty) return 0.0;
    int totalPercentage = dailyProgress.fold(
        0, (sum, item) => sum + (item['percentage'] as int));
    return totalPercentage / dailyProgress.length;
  }

  // GET COLOR from HEX
  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  // GET ICON from name
  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'mosque':
        return Icons.mosque;
      case 'menu_book':
        return Icons.menu_book;
      case 'favorite':
        return Icons.favorite;
      case 'favorite_border':
        return Icons.favorite_border;
      case 'emoji_events':
        return Icons.emoji_events;
      default:
        return Icons.stars;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text(progressTitle),
          centerTitle: true,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    double progressPercentage = getProgressToNextLevel() * 100;
    int pointsNeeded = getPointsNeeded();
    double weeklyAvg = getWeeklyAverage();
    int currentStreak = streakInfo['currentStreak'] ?? 0;
    int longestStreak = streakInfo['longestStreak'] ?? 0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(progressTitle),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // GAMIFICATION SECTION - LEVEL & POINTS
                Container(
                  padding: const EdgeInsets.all(paddingMedium),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColorDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Level Circle
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: textColorWhite,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Level',
                                    style: TextStyle(
                                      color: textColorWhite,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    '$currentLevel',
                                    style: const TextStyle(
                                      color: textColorWhite,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Stats
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: paddingMedium),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ibadah Konsisten',
                                    style: TextStyle(
                                      color: textColorWhite,
                                      fontSize: fontSizeMedium,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$totalPoints Poin',
                                    style: const TextStyle(
                                      color: textColorWhite,
                                      fontSize: fontSizeNormal,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department,
                                        color: accentColor,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$currentStreak hari streak',
                                        style: const TextStyle(
                                          color: accentColor,
                                          fontSize: fontSizeSmall,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: paddingNormal),

                      // Progress to next level
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Progress ke Level 4:',
                                style: TextStyle(
                                  color: textColorWhite,
                                  fontSize: fontSizeSmall,
                                ),
                              ),
                              Text(
                                '${progressPercentage.toStringAsFixed(0)}% ($pointsNeeded poin)',
                                style: const TextStyle(
                                  color: textColorWhite,
                                  fontSize: fontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: paddingSmall),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: getProgressToNextLevel(),
                              minHeight: 10,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: paddingLarge),

                // STREAK SECTION
                Container(
                  padding: const EdgeInsets.all(paddingNormal),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                    border: Border.all(color: accentColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(paddingSmall),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(borderRadiusSmall),
                        ),
                        child: const Icon(
                          Icons.local_fire_department,
                          color: textColorWhite,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: paddingNormal),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$currentStreak Hari Berturut-turut! 🔥',
                              style: const TextStyle(
                                fontSize: fontSizeMedium,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Terbaik: $longestStreak hari',
                              style: const TextStyle(
                                fontSize: fontSizeSmall,
                                color: textColorLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: paddingNormal),

                // DAILY PROGRESS CHART
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress 7 Hari Terakhir',
                          style: TextStyle(
                            fontSize: fontSizeLarge,
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
                            color: primaryColor.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(borderRadiusSmall),
                          ),
                          child: Text(
                            'Rata-rata: ${weeklyAvg.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: fontSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
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
                      child: dailyProgress.isEmpty
                          ? const Center(
                              child: Text('Tidak ada data progress'),
                            )
                          : SizedBox(
                              height: 120,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: dailyProgress.map((day) {
                                  final percentage = day['percentage'] as int;
                                  final isToday = day == dailyProgress.last;

                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '$percentage%',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isToday
                                                  ? primaryColor
                                                  : textColorLight,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Container(
                                            width: double.infinity,
                                            height: (percentage / 100) * 80,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: isToday
                                                    ? [
                                                        primaryColor,
                                                        primaryColorDark
                                                      ]
                                                    : percentage >= 75
                                                        ? [
                                                            successColor,
                                                            Color(0xFF388E3C)
                                                          ]
                                                        : percentage >= 50
                                                            ? [
                                                                accentColor,
                                                                Color(
                                                                    0xFFFFA000)
                                                              ]
                                                            : [
                                                                errorColor,
                                                                Color(
                                                                    0xFFD32F2F)
                                                              ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            day['day'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: isToday
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              color: isToday
                                                  ? primaryColor
                                                  : textColorLight,
                                            ),
                                          ),
                                          Text(
                                            '${day['completed']}/${day['total']}',
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: textColorLighter,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                  ],
                ),

                const SizedBox(height: paddingLarge),

                // CATEGORY STATISTICS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statistik Per Kategori',
                      style: TextStyle(
                        fontSize: fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: paddingNormal),
                    categoryStats.isEmpty
                        ? const Text('Tidak ada data kategori')
                        : Column(
                            children: categoryStats.map((category) {
                              final percentage = category['percentage'] as int;
                              final color = _getColorFromHex(
                                  category['color'].toString());
                              final icon = _getIconFromName(
                                  category['icon'].toString());

                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: paddingMedium),
                                child: Container(
                                  padding: const EdgeInsets.all(paddingMedium),
                                  decoration: BoxDecoration(
                                    color: cardBackgroundColor,
                                    borderRadius: BorderRadius.circular(
                                        borderRadiusNormal),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(
                                                paddingSmall),
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      borderRadiusSmall),
                                            ),
                                            child: Icon(
                                              icon,
                                              color: color,
                                              size: iconSizeNormal,
                                            ),
                                          ),
                                          const SizedBox(width: paddingNormal),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  category['name'].toString(),
                                                  style: const TextStyle(
                                                    fontSize: fontSizeMedium,
                                                    fontWeight: FontWeight.w600,
                                                    color: textColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${category['completed']}/${category['total']} selesai',
                                                  style: const TextStyle(
                                                    fontSize: fontSizeSmall,
                                                    color: textColorLight,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: paddingSmall,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: color.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      borderRadiusSmall),
                                            ),
                                            child: Text(
                                              '$percentage%',
                                              style: TextStyle(
                                                fontSize: fontSizeMedium,
                                                fontWeight: FontWeight.bold,
                                                color: color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: paddingNormal),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          value: percentage / 100,
                                          minHeight: 8,
                                          backgroundColor: dividerColor,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),

                const SizedBox(height: paddingLarge),

                // ACHIEVEMENT SECTION
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pencapaian',
                          style: TextStyle(
                            fontSize: fontSizeLarge,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '${achievements.where((a) => a['unlocked']).length}/${achievements.length} terbuka',
                          style: const TextStyle(
                            fontSize: fontSizeSmall,
                            color: textColorLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: paddingNormal),
                    achievements.isEmpty
                        ? const Text('Tidak ada data achievement')
                        : Column(
                            children: achievements.map((achievement) {
                              final unlocked = achievement['unlocked'] as bool;
                              final color = _getColorFromHex(
                                  achievement['color'].toString());
                              final icon = _getIconFromName(
                                  achievement['icon'].toString());

                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: paddingNormal),
                                child: Container(
                                  padding: const EdgeInsets.all(paddingMedium),
                                  decoration: BoxDecoration(
                                    color: unlocked
                                        ? color.withOpacity(0.1)
                                        : cardBackgroundColor,
                                    borderRadius: BorderRadius.circular(
                                        borderRadiusNormal),
                                    border: Border.all(
                                      color: unlocked ? color : borderColor,
                                      width: unlocked ? 2 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: unlocked
                                              ? color
                                              : dividerColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          icon,
                                          color: unlocked
                                              ? textColorWhite
                                              : textColorLight,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: paddingMedium),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              achievement['title'].toString(),
                                              style: TextStyle(
                                                fontSize: fontSizeNormal,
                                                fontWeight: FontWeight.w600,
                                                color: unlocked
                                                    ? textColor
                                                    : textColorLight,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              achievement['description']
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: fontSizeSmall,
                                                color: unlocked
                                                    ? textColorLight
                                                    : textColorLighter,
                                              ),
                                            ),
                                            if (unlocked &&
                                                achievement['unlockedDate'] !=
                                                    null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: paddingSmall),
                                                child: Text(
                                                  'Didapat: ${achievement['unlockedDate']}',
                                                  style: TextStyle(
                                                    fontSize: fontSizeSmall,
                                                    color: color,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (unlocked)
                                        Icon(
                                          Icons.check_circle,
                                          color: color,
                                          size: iconSizeNormal,
                                        )
                                      else
                                        Icon(
                                          Icons.lock,
                                          color: textColorLighter,
                                          size: iconSizeNormal,
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),

                const SizedBox(height: paddingLarge),

                // MOTIVATION BOX
                Container(
                  padding: const EdgeInsets.all(paddingMedium),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        infoColor.withOpacity(0.1),
                        infoColor.withOpacity(0.05)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                    border: Border.all(color: infoColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: infoColor,
                        size: iconSizeMedium,
                      ),
                      const SizedBox(width: paddingMedium),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '💪 Motivasi Hari Ini:',
                              style: TextStyle(
                                fontSize: fontSizeNormal,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: paddingSmall),
                            Text(
                              motivationalMessage.isEmpty
                                  ? 'Terus semangat menjalankan ibadah!'
                                  : motivationalMessage,
                              style: const TextStyle(
                                fontSize: fontSizeSmall,
                                color: textColorLight,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: paddingMedium),
              ],
            ),
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

  // INFO DIALOG
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Poin & Level'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Cara Mendapat Poin:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizeMedium,
                ),
              ),
              SizedBox(height: paddingSmall),
              Text('• Selesaikan target: +10 poin'),
              Text('• Selesaikan semua target hari ini: +50 poin'),
              Text('• Streak 7 hari: +100 poin'),
              Text('• Unlock achievement: +50 poin'),
              SizedBox(height: paddingMedium),
              Text(
                'Level:',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: fontSizeMedium,
                ),
              ),
              SizedBox(height: paddingSmall),
              Text('Level 1: 0-500 poin'),
              Text('Level 2: 500-1500 poin'),
              Text('Level 3: 1500-3000 poin'),
              Text('Level 4: 3000-5000 poin'),
              Text('Level 5: 5000+ poin'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}