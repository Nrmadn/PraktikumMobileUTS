import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/json_service.dart';
import '../widgets/bottom_navigation.dart';

// UPDATE: Load jadwal sholat dari JSON

class SholatScreen extends StatefulWidget {
  const SholatScreen({Key? key}) : super(key: key);

  @override
  State<SholatScreen> createState() => _SholatScreenState();
}

class _SholatScreenState extends State<SholatScreen> {
  int selectedNavIndex = 0;
  bool isLoading = true;

  Map<String, String> prayerTimes = {};
  Map<String, String> nextPrayerInfo = {};

  // Icon mapping untuk setiap waktu sholat
  final Map<String, String> prayerIcons = {
    'Subuh': '🌙',
    'Dhuhur': '☀️',
    'Ashar': '🌤️',
    'Maghrib': '🌅',
    'Isya': '🌙',
  };

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  // LOAD DATA dari JSON
  Future<void> _loadJsonData() async {
    try {
      final results = await Future.wait([
        JsonService.getPrayerTimesMap(),
        JsonService.getNextPrayerInfo(),
      ]);

      setState(() {
        prayerTimes = results[0] as Map<String, String>;
        nextPrayerInfo = results[1] as Map<String, String>;
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

  // Format date
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Jadwal Sholat'),
          centerTitle: true,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Get next prayer name
    final nextPrayerName = nextPrayerInfo['name'] ?? '';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Jadwal Sholat'),
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
                  'Jadwal Sholat Hari Ini',
                  style: TextStyle(
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

                const SizedBox(height: paddingLarge),

                // SHOLAT TIMES LIST
                prayerTimes.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(paddingLarge),
                          child: Text(
                            'Jadwal sholat tidak tersedia',
                            style: TextStyle(
                              fontSize: fontSizeNormal,
                              color: textColorLight,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: prayerTimes.entries.map((entry) {
                          final sholatName = entry.key;
                          final sholatTime = entry.value;
                          final isNextPrayer = sholatName == nextPrayerName;
                          final icon = prayerIcons[sholatName] ?? '🕌';

                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: paddingMedium),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadiusNormal),
                                side: isNextPrayer
                                    ? const BorderSide(
                                        color: primaryColor, width: 2)
                                    : BorderSide.none,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(borderRadiusNormal),
                                  gradient: isNextPrayer
                                      ? LinearGradient(
                                          colors: [
                                            primaryColor.withOpacity(0.1),
                                            primaryColor.withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        )
                                      : null,
                                ),
                                padding: const EdgeInsets.all(paddingMedium),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              icon,
                                              style:
                                                  const TextStyle(fontSize: 24),
                                            ),
                                            const SizedBox(width: paddingSmall),
                                            Text(
                                              sholatName,
                                              style: TextStyle(
                                                fontSize: fontSizeMedium,
                                                fontWeight: FontWeight.w600,
                                                color: isNextPrayer
                                                    ? primaryColor
                                                    : textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: paddingSmall),
                                        if (isNextPrayer)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: paddingSmall,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      borderRadiusSmall),
                                            ),
                                            child: const Text(
                                              'Sholat Berikutnya',
                                              style: TextStyle(
                                                fontSize: fontSizeSmall,
                                                color: textColorWhite,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          sholatTime,
                                          style: TextStyle(
                                            fontSize: fontSizeXLarge,
                                            fontWeight: FontWeight.bold,
                                            color: isNextPrayer
                                                ? primaryColor
                                                : textColor,
                                          ),
                                        ),
                                        const SizedBox(height: paddingSmall),
                                        if (isNextPrayer &&
                                            nextPrayerInfo['countdown'] != null)
                                          Text(
                                            'dalam ${nextPrayerInfo['countdown']}',
                                            style: const TextStyle(
                                              fontSize: fontSizeSmall,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                const SizedBox(height: paddingMedium),

                // REMINDER SECTION
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
                      const Text(
                        '🔔 Pengingat Sholat',
                        style: TextStyle(
                          fontSize: fontSizeNormal,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: paddingSmall),
                      const Text(
                        'Fitur pengingat sholat akan segera diaktifkan. Anda akan menerima notifikasi pada waktu sholat.',
                        style: TextStyle(
                          fontSize: fontSizeSmall,
                          color: textColorLight,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: paddingMedium),
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Fitur notifikasi akan tersedia di versi lengkap'),
                                  backgroundColor: warningColor,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            activeColor: primaryColor,
                          ),
                          const Text(
                            'Aktifkan notifikasi sholat',
                            style: TextStyle(
                              fontSize: fontSizeSmall,
                              color: textColor,
                            ),
                          ),
                        ],
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