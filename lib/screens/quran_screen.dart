import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/json_service.dart';
import '../widgets/bottom_navigation.dart';

// UPDATE: Load surah list dari JSON

class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  int selectedNavIndex = 0;
  bool isLoading = true;

  List<Map<String, dynamic>> surahList = [];
  Map<String, String> readingTips = {};

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  // LOAD DATA dari JSON
  Future<void> _loadJsonData() async {
    try {
      final results = await Future.wait([
        JsonService.getSurahList(),
        JsonService.getReadingTips(),
      ]);

      setState(() {
        surahList = results[0] as List<Map<String, dynamic>>;
        readingTips = results[1] as Map<String, String>;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading JSON data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleNavigation(int index) {
    setState(() {
      selectedNavIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/progress');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/prayer_time');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/setting');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Al-Qur\'an'),
          centerTitle: true,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Al-Qur\'an'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                const Text(
                  'Daftar Surah',
                  style: TextStyle(
                    fontSize: fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: paddingSmall),
                const Text(
                  'Lacak progress membaca Al-Qur\'an Anda',
                  style: TextStyle(
                    fontSize: fontSizeNormal,
                    color: textColorLight,
                  ),
                ),

                const SizedBox(height: paddingLarge),

                // SURAH LIST
                surahList.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(paddingLarge),
                          child: Text(
                            'Tidak ada data surah',
                            style: TextStyle(
                              fontSize: fontSizeNormal,
                              color: textColorLight,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: surahList.map((surah) {
                          final progress = surah['progress'] as Map<String, dynamic>;
                          int completed = progress['completed'] as int;
                          int total = progress['total'] as int;
                          double progressValue = completed / total;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: paddingMedium),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadiusNormal),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(paddingMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                surah['name'].toString(),
                                                style: const TextStyle(
                                                  fontSize: fontSizeMedium,
                                                  fontWeight: FontWeight.w600,
                                                  color: textColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              if (surah['arabicName'] != null)
                                                Text(
                                                  surah['arabicName'].toString(),
                                                  style: const TextStyle(
                                                    fontSize: fontSizeNormal,
                                                    color: textColorLight,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${surah['verses']} ayat',
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
                                            color: progressValue == 1.0
                                                ? successColor.withOpacity(0.2)
                                                : primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                                borderRadiusSmall),
                                          ),
                                          child: Text(
                                            '$completed/$total',
                                            style: TextStyle(
                                              fontSize: fontSizeSmall,
                                              fontWeight: FontWeight.w600,
                                              color: progressValue == 1.0
                                                  ? successColor
                                                  : primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: paddingMedium),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: progressValue,
                                        minHeight: 8,
                                        backgroundColor: dividerColor,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          progressValue == 1.0
                                              ? successColor
                                              : primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                const SizedBox(height: paddingMedium),

                // INFO BOX - Reading Tips
                if (readingTips.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(paddingMedium),
                    decoration: BoxDecoration(
                      color: infoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadiusNormal),
                      border: Border.all(color: infoColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          readingTips['title'] ?? '📖 Tips Membaca',
                          style: const TextStyle(
                            fontSize: fontSizeNormal,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: paddingSmall),
                        Text(
                          readingTips['description'] ??
                              'Target membaca 2-3 halaman setiap hari untuk menyelesaikan Al-Qur\'an dalam satu bulan.',
                          style: const TextStyle(
                            fontSize: fontSizeSmall,
                            color: textColorLight,
                            height: 1.5,
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
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: selectedNavIndex,
        onTap: handleNavigation,
      ),
    );
  }
}