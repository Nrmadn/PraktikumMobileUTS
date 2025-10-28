import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/target_ibadah_model.dart';

// Service untuk load data dari JSON files
// Semua data static/master ada di assets/data/

class JsonService {
  //  PRIVATE HELPER - LOAD JSON FILE
  static Future<Map<String, dynamic>> _loadJsonFile(String path) async {
    try {
      final String response = await rootBundle.loadString(path);
      return json.decode(response);
    } catch (e) {
      print('Error loading JSON from $path: $e');
      return {};
    }
  }

  //  PRAYER TIMES
  static Future<Map<String, dynamic>> loadPrayerTimes() async {
    return await _loadJsonFile('assets/data/prayer_times.json');
  }

  // Parse prayer times untuk mudah dipakai
  static Future<Map<String, String>> getPrayerTimesMap() async {
    final data = await loadPrayerTimes();
    final times = data['times'] as Map<String, dynamic>?;
    
    if (times == null) return {};
    
    return times.map((key, value) => MapEntry(key, value.toString()));
  }

  // Get next prayer info
  static Future<Map<String, String>> getNextPrayerInfo() async {
    final data = await loadPrayerTimes();
    final nextPrayer = data['nextPrayer'] as Map<String, dynamic>?;
    
    if (nextPrayer == null) return {};
    
    return {
      'name': nextPrayer['name']?.toString() ?? '',
      'time': nextPrayer['time']?.toString() ?? '',
      'countdown': nextPrayer['countdown']?.toString() ?? '',
    };
  }

  //  SURAH LIST
  static Future<Map<String, dynamic>> loadSurahList() async {
    return await _loadJsonFile('assets/data/surah_list.json');
  }

  // Get list of surah
  static Future<List<Map<String, dynamic>>> getSurahList() async {
    final data = await loadSurahList();
    final surahList = data['surah'] as List<dynamic>?;
    
    if (surahList == null) return [];
    
    return surahList.map((surah) => surah as Map<String, dynamic>).toList();
  }

  // Get reading tips
  static Future<Map<String, String>> getReadingTips() async {
    final data = await loadSurahList();
    final tips = data['readingTips'] as Map<String, dynamic>?;
    
    if (tips == null) return {};
    
    return {
      'title': tips['title']?.toString() ?? '',
      'description': tips['description']?.toString() ?? '',
    };
  }

  //  ACHIEVEMENTS
  static Future<Map<String, dynamic>> loadAchievements() async {
    return await _loadJsonFile('assets/data/achievements.json');
  }

  // Get list of achievements
  static Future<List<Map<String, dynamic>>> getAchievementsList() async {
    final data = await loadAchievements();
    final achievements = data['achievements'] as List<dynamic>?;
    
    if (achievements == null) return [];
    
    return achievements.map((ach) => ach as Map<String, dynamic>).toList();
  }

  // Get points system
  static Future<Map<String, int>> getPointsSystem() async {
    final data = await loadAchievements();
    final pointsSystem = data['pointsSystem'] as Map<String, dynamic>?;
    
    if (pointsSystem == null) return {};
    
    return pointsSystem.map((key, value) => MapEntry(key, value as int));
  }

  //  CATEGORIES
  static Future<Map<String, dynamic>> loadCategories() async {
    return await _loadJsonFile('assets/data/categories.json');
  }

  // Get list of categories
  static Future<List<Map<String, dynamic>>> getCategoriesList() async {
    final data = await loadCategories();
    final categories = data['categories'] as List<dynamic>?;
    
    if (categories == null) return [];
    
    return categories.map((cat) => cat as Map<String, dynamic>).toList();
  }

  // Get category names only
  static Future<List<String>> getCategoryNames() async {
    final categories = await getCategoriesList();
    return categories.map((cat) => cat['name'].toString()).toList();
  }

  //  DUMMY TARGETS
  static Future<Map<String, dynamic>> loadDummyTargets() async {
    return await _loadJsonFile('assets/data/dummy_targets.json');
  }

  // Get list of targets
  static Future<List<TargetIbadah>> getTargetsList() async {
    final data = await loadDummyTargets();
    final targets = data['targets'] as List<dynamic>?;
    
    if (targets == null) return [];
    
    return targets.map((target) {
      return TargetIbadah.fromJson(target as Map<String, dynamic>);
    }).toList();
  }

  // Get targets for today
  static Future<List<TargetIbadah>> getTodayTargets() async {
    final allTargets = await getTargetsList();
    final today = DateTime.now();
    
    return allTargets.where((target) {
      return target.targetDate.year == today.year &&
          target.targetDate.month == today.month &&
          target.targetDate.day == today.day;
    }).toList();
  }

  //  DZIKIR LIST
  static Future<Map<String, dynamic>> loadDzikirList() async {
    return await _loadJsonFile('assets/data/dzikir_list.json');
  }

  // Get list of dzikir
  static Future<List<Map<String, dynamic>>> getDzikirList() async {
    final data = await loadDzikirList();
    final dzikirList = data['dzikirList'] as List<dynamic>?;
    
    if (dzikirList == null) return [];
    
    return dzikirList.map((dzikir) => dzikir as Map<String, dynamic>).toList();
  }

  // Get dzikir names only
  static Future<List<String>> getDzikirNames() async {
    final dzikirList = await getDzikirList();
    return dzikirList.map((dzikir) => dzikir['name'].toString()).toList();
  }

  // Get dzikir benefits
  static Future<Map<String, String>> getDzikirBenefits() async {
    final data = await loadDzikirList();
    final benefits = data['benefits'] as Map<String, dynamic>?;
    
    if (benefits == null) return {};
    
    return {
      'title': benefits['title']?.toString() ?? '',
      'description': benefits['description']?.toString() ?? '',
    };
  }

  // SEDEKAH HISTORY
  static Future<Map<String, dynamic>> loadSedekahHistory() async {
    return await _loadJsonFile('assets/data/sedekah_history.json');
  }

  // Get sedekah history
  static Future<List<Map<String, dynamic>>> getSedekahHistory() async {
    final data = await loadSedekahHistory();
    final history = data['history'] as List<dynamic>?;
    
    if (history == null) return [];
    
    return history.map((item) => item as Map<String, dynamic>).toList();
  }

  // Get sedekah categories
  static Future<List<String>> getSedekahCategories() async {
    final data = await loadSedekahHistory();
    final categories = data['categories'] as List<dynamic>?;
    
    if (categories == null) return [];
    
    return categories.map((cat) => cat.toString()).toList();
  }

  // Get sedekah tips
  static Future<Map<String, dynamic>> getSedekahTips() async {
    final data = await loadSedekahHistory();
    return data['tips'] as Map<String, dynamic>? ?? {};
  }

  // Calculate total sedekah
  static Future<int> getTotalSedekah() async {
    final history = await getSedekahHistory();
    return history.fold<int>(0, (int sum, Map<String, dynamic> item) => sum + (item['jumlah'] as int));
  }

  // PROGRESS STATS
  static Future<Map<String, dynamic>> loadProgressStats() async {
    return await _loadJsonFile('assets/data/progress_stats.json');
  }

  // Get daily progress (7 days)
  static Future<List<Map<String, dynamic>>> getDailyProgress() async {
    final data = await loadProgressStats();
    final dailyProgress = data['dailyProgress'] as List<dynamic>?;
    
    if (dailyProgress == null) return [];
    
    return dailyProgress.map((day) => day as Map<String, dynamic>).toList();
  }

  // Get category stats
  static Future<List<Map<String, dynamic>>> getCategoryStats() async {
    final data = await loadProgressStats();
    final categoryStats = data['categoryStats'] as List<dynamic>?;
    
    if (categoryStats == null) return [];
    
    return categoryStats.map((stat) => stat as Map<String, dynamic>).toList();
  }

  // Get streak info
  static Future<Map<String, dynamic>> getStreakInfo() async {
    final data = await loadProgressStats();
    return data['streakInfo'] as Map<String, dynamic>? ?? {};
  }

  // Get random motivational message
  static Future<String> getMotivationalMessage() async {
    final data = await loadProgressStats();
    final messages = data['motivationalMessages'] as List<dynamic>?;
    
    if (messages == null || messages.isEmpty) {
      return 'Terus semangat menjalankan ibadah!';
    }
    
    // Return random message
    messages.shuffle();
    return messages.first.toString();
  }

  // Calculate weekly average
  static Future<double> getWeeklyAverage() async {
    final dailyProgress = await getDailyProgress();
    
    if (dailyProgress.isEmpty) return 0.0;
    
    int totalPercentage = dailyProgress.fold(
      0, 
      (sum, item) => sum + (item['percentage'] as int)
    );
    
    return totalPercentage / dailyProgress.length;
  }

  // LOAD ALL DATA (for preloading)
  static Future<void> preloadAllData() async {
    try {
      await Future.wait([
        loadPrayerTimes(),
        loadSurahList(),
        loadAchievements(),
        loadCategories(),
        loadDummyTargets(),
        loadDzikirList(),
        loadSedekahHistory(),
        loadProgressStats(),
      ]);
      print('✅ All JSON data preloaded successfully');
    } catch (e) {
      print('❌ Error preloading data: $e');
    }
  }
}

