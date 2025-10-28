import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/json_service.dart';
import '../widgets/bottom_navigation.dart';

// UPDATE: Load sedekah history dari JSON, input disabled

class SedekahScreen extends StatefulWidget {
  const SedekahScreen({Key? key}) : super(key: key);

  @override
  State<SedekahScreen> createState() => _SedekahScreenState();
}

class _SedekahScreenState extends State<SedekahScreen> {
  int selectedNavIndex = 0;
  late TextEditingController jumlahController;
  bool isLoading = true;

  List<Map<String, dynamic>> sedekahHistory = [];
  List<String> sedekahCategories = [];
  Map<String, dynamic> tips = {};
  int totalSedekah = 0;

  @override
  void initState() {
    super.initState();
    jumlahController = TextEditingController();
    _loadJsonData();
  }

  @override
  void dispose() {
    jumlahController.dispose();
    super.dispose();
  }

  // LOAD DATA dari JSON
  Future<void> _loadJsonData() async {
    try {
      final results = await Future.wait([
        JsonService.getSedekahHistory(),
        JsonService.getSedekahCategories(),
        JsonService.getSedekahTips(),
        JsonService.getTotalSedekah(),
      ]);

      setState(() {
        sedekahHistory = results[0] as List<Map<String, dynamic>>;
        sedekahCategories = results[1] as List<String>;
        tips = results[2] as Map<String, dynamic>;
        totalSedekah = results[3] as int;
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
        Navigator.pushReplacementNamed(context, '/progress_home');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/setting');
        break;
    }
  }

  // FORMAT RUPIAH
  String _formatRupiah(int amount) {
    return amount
        .toString()
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  // HANDLE ADD SEDEKAH - DISABLED
  void handleAddSedekah() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur tambah sedekah akan tersedia di versi lengkap'),
        backgroundColor: warningColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text('Sedekah'),
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
        title: const Text('Sedekah'),
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
                  'Tracking Sedekah',
                  style: TextStyle(
                    fontSize: fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: paddingSmall),
                const Text(
                  'Catat setiap sedekah yang Anda lakukan',
                  style: TextStyle(
                    fontSize: fontSizeNormal,
                    color: textColorLight,
                  ),
                ),

                const SizedBox(height: paddingLarge),

                // TOTAL SEDEKAH
                Container(
                  padding: const EdgeInsets.all(paddingMedium),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryColor, primaryColorDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Sedekah Bulan Ini',
                        style: TextStyle(
                          color: textColorWhite,
                          fontSize: fontSizeNormal,
                        ),
                      ),
                      const SizedBox(height: paddingSmall),
                      Text(
                        'Rp${_formatRupiah(totalSedekah)}',
                        style: const TextStyle(
                          color: textColorWhite,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: paddingSmall),
                      Text(
                        '${sedekahHistory.length} kali sedekah',
                        style: const TextStyle(
                          color: textColorWhite,
                          fontSize: fontSizeSmall,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: paddingLarge),

                // INPUT SEDEKAH (DISABLED)
                const Text(
                  'Tambah Sedekah',
                  style: TextStyle(
                    fontSize: fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: paddingSmall),
                TextField(
                  controller: jumlahController,
                  keyboardType: TextInputType.number,
                  enabled: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: dividerColor,
                    hintText: 'Masukkan jumlah sedekah (Rp)',
                    hintStyle: const TextStyle(color: textColorLighter),
                    prefixIcon: const Icon(Icons.attach_money, color: textColorLight),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadiusNormal),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadiusNormal),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadiusNormal),
                      borderSide: const BorderSide(color: borderColor),
                    ),
                  ),
                ),

                const SizedBox(height: paddingMedium),

                SizedBox(
                  width: double.infinity,
                  height: buttonHeightNormal,
                  child: ElevatedButton(
                    onPressed: handleAddSedekah,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: successColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadiusNormal),
                      ),
                    ),
                    child: const Text(
                      'Catat Sedekah',
                      style: TextStyle(
                        color: textColorWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: paddingLarge),

                // RIWAYAT SEDEKAH
                const Text(
                  'Riwayat Sedekah',
                  style: TextStyle(
                    fontSize: fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: paddingMedium),

                sedekahHistory.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(paddingLarge),
                          child: Text(
                            'Belum ada riwayat sedekah',
                            style: TextStyle(
                              fontSize: fontSizeNormal,
                              color: textColorLight,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: sedekahHistory.map((item) {
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
                                child: Row(
                                  children: [
                                    // Icon
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: successColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            borderRadiusNormal),
                                      ),
                                      child: const Icon(
                                        Icons.favorite,
                                        color: successColor,
                                        size: iconSizeNormal,
                                      ),
                                    ),
                                    const SizedBox(width: paddingNormal),
                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['keterangan'].toString(),
                                            style: const TextStyle(
                                              fontSize: fontSizeMedium,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: paddingSmall),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 14,
                                                color: textColorLight,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                item['tanggal'].toString(),
                                                style: const TextStyle(
                                                  fontSize: fontSizeSmall,
                                                  color: textColorLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (item['category'] != null) ...[
                                            const SizedBox(height: paddingSmall),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: paddingSmall,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: infoColor
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        borderRadiusSmall),
                                                border: Border.all(
                                                    color: infoColor),
                                              ),
                                              child: Text(
                                                item['category'].toString(),
                                                style: const TextStyle(
                                                  fontSize: fontSizeSmall,
                                                  color: infoColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    // Amount
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: paddingSmall,
                                        vertical: paddingXSmall,
                                      ),
                                      decoration: BoxDecoration(
                                        color: successColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            borderRadiusSmall),
                                      ),
                                      child: Text(
                                        'Rp${_formatRupiah(item['jumlah'] as int)}',
                                        style: const TextStyle(
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
                          );
                        }).toList(),
                      ),

                const SizedBox(height: paddingLarge),

                // TIPS SEDEKAH
                if (tips.isNotEmpty)
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
                          tips['title']?.toString() ?? '💰 Tips Sedekah',
                          style: const TextStyle(
                            fontSize: fontSizeNormal,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: paddingSmall),
                        if (tips['items'] != null)
                          ...(tips['items'] as List<dynamic>).map((tip) {
                            return Padding(
                              padding: const EdgeInsets.only(top: paddingSmall),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '• ',
                                    style: TextStyle(
                                      fontSize: fontSizeSmall,
                                      color: textColorLight,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      tip.toString(),
                                      style: const TextStyle(
                                        fontSize: fontSizeSmall,
                                        color: textColorLight,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
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