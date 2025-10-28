import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/target_ibadah_model.dart';
import '../services/json_service.dart';
import '../widgets/bottom_navigation.dart';

// UPDATE: Navigasi Add/Edit berfungsi, tapi simpan/update disabled dengan message

class ProgressHomeScreen extends StatefulWidget {
  const ProgressHomeScreen({Key? key}) : super(key: key);

  @override
  State<ProgressHomeScreen> createState() => _ProgressHomeScreenState();
}

class _ProgressHomeScreenState extends State<ProgressHomeScreen> {
  // 📋 VARIABLES
  int selectedNavIndex = 2;
  String selectedFilter = 'Semua';
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  List<TargetIbadah> targets = [];
  List<String> filterCategories = ['Semua'];

  @override
  void initState() {
    super.initState();
    _loadJsonData();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // LOAD DATA dari JSON
  Future<void> _loadJsonData() async {
    try {
      final results = await Future.wait([
        JsonService.getTargetsList(),
        JsonService.getCategoryNames(),
      ]);

      setState(() {
        targets = results[0] as List<TargetIbadah>;
        final categories = results[1] as List<String>;
        filterCategories = ['Semua', ...categories];
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
        Navigator.pushNamed(context, '/progress');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
      case 4:
        Navigator.pushNamed(context, '/setting');
        break;
    }
  }

  // FILTER & SEARCH TARGETS
  List<TargetIbadah> getFilteredTargets() {
    List<TargetIbadah> filtered = targets;

    if (selectedFilter != 'Semua') {
      filtered = filtered.where((t) => t.category == selectedFilter).toList();
    }

    if (searchController.text.isNotEmpty) {
      filtered = filtered
          .where((t) =>
              t.name.toLowerCase().contains(searchController.text.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  // GET STATISTICS
  Map<String, int> getStatistics() {
    int total = targets.length;
    int completed = targets.where((t) => t.isCompleted).length;
    int today = targets.where((t) => t.isForToday()).length;
    int overdue = targets.where((t) => t.isOverdue()).length;

    return {
      'total': total,
      'completed': completed,
      'today': today,
      'overdue': overdue,
    };
  }

  // DELETE TARGET - DISABLED (Show message)
  void handleDeleteTarget(String targetId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Target?'),
        content: const Text('Fitur hapus target akan tersedia di versi lengkap'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ✅ HANDLE EDIT TARGET - NAVIGASI BERFUNGSI
  void handleEditTarget(TargetIbadah target) {
    Navigator.pushNamed(
      context,
      '/edit_target',
      arguments: target,
    ).then((result) {
      // Jika ada result (data yang dikembalikan), tampilkan pesan
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fitur edit target akan tersedia di versi lengkap'),
            backgroundColor: warningColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  // ✅ HANDLE ADD TARGET - NAVIGASI BERFUNGSI
  void handleAddTarget() {
    Navigator.pushNamed(context, '/add_target').then((result) {
      // Jika ada result (data yang dikembalikan), tampilkan pesan
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fitur tambah target akan tersedia di versi lengkap'),
            backgroundColor: warningColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  // TOGGLE COMPLETION - DISABLED (Show message)
  void toggleTargetCompletion(String targetId, bool newValue) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur ini akan tersedia di versi lengkap'),
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
          title: const Text('Manajemen Target'),
          centerTitle: true,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final filteredTargets = getFilteredTargets();
    final stats = getStatistics();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Manajemen Target'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // STATISTICS CARDS
            Container(
              padding: const EdgeInsets.all(paddingMedium),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total',
                      stats['total']!.toString(),
                      Icons.task_alt,
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: paddingSmall),
                  Expanded(
                    child: _buildStatCard(
                      'Selesai',
                      stats['completed']!.toString(),
                      Icons.check_circle,
                      successColor,
                    ),
                  ),
                  const SizedBox(width: paddingSmall),
                  Expanded(
                    child: _buildStatCard(
                      'Hari Ini',
                      stats['today']!.toString(),
                      Icons.today,
                      accentColor,
                    ),
                  ),
                  const SizedBox(width: paddingSmall),
                  Expanded(
                    child: _buildStatCard(
                      'Terlambat',
                      stats['overdue']!.toString(),
                      Icons.warning,
                      errorColor,
                    ),
                  ),
                ],
              ),
            ),

            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Cari target...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadiusNormal),
                  ),
                ),
              ),
            ),

            const SizedBox(height: paddingMedium),

            // FILTER CATEGORIES
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: paddingMedium),
                  child: Row(
                    children: filterCategories.map((category) {
                      final isSelected = selectedFilter == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: paddingSmall),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (value) {
                            setState(() {
                              selectedFilter = category;
                            });
                          },
                          backgroundColor: cardBackgroundColor,
                          selectedColor: primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? textColorWhite : textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: paddingMedium),

            // TARGET LIST
            Expanded(
              child: filteredTargets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 64,
                            color: textColorLighter,
                          ),
                          const SizedBox(height: paddingMedium),
                          Text(
                            searchController.text.isNotEmpty
                                ? 'Tidak ada target yang cocok'
                                : 'Tidak ada target',
                            style: TextStyle(
                              fontSize: fontSizeNormal,
                              color: textColorLight,
                            ),
                          ),
                          const SizedBox(height: paddingSmall),
                          TextButton.icon(
                            onPressed: handleAddTarget,
                            icon: const Icon(Icons.add),
                            label: const Text('Tambah Target'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: paddingMedium),
                      itemCount: filteredTargets.length,
                      itemBuilder: (context, index) {
                        final target = filteredTargets[index];
                        final isOverdue = target.isOverdue();
                        final isToday = target.isForToday();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: paddingNormal),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  borderRadiusNormal),
                              side: isOverdue
                                  ? BorderSide(color: errorColor, width: 2)
                                  : BorderSide.none,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(paddingMedium),
                              leading: Checkbox(
                                value: target.isCompleted,
                                onChanged: (value) {
                                  toggleTargetCompletion(
                                      target.id, value ?? false);
                                },
                                activeColor: successColor,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    target.name,
                                    style: TextStyle(
                                      fontSize: fontSizeMedium,
                                      fontWeight: FontWeight.w600,
                                      decoration: target.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      color: target.isCompleted
                                          ? textColorLight
                                          : textColor,
                                    ),
                                  ),
                                  const SizedBox(height: paddingSmall),
                                  Wrap(
                                    spacing: paddingSmall,
                                    runSpacing: paddingSmall,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: paddingSmall,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.circular(
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
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: paddingSmall,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isOverdue
                                              ? errorColor.withOpacity(0.1)
                                              : isToday
                                                  ? accentColor.withOpacity(0.1)
                                                  : infoColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                              borderRadiusSmall),
                                          border: Border.all(
                                            color: isOverdue
                                                ? errorColor
                                                : isToday
                                                    ? accentColor
                                                    : infoColor,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 12,
                                              color: isOverdue
                                                  ? errorColor
                                                  : isToday
                                                      ? accentColor
                                                      : infoColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              target.getFormattedDate(),
                                              style: TextStyle(
                                                color: isOverdue
                                                    ? errorColor
                                                    : isToday
                                                        ? accentColor
                                                        : infoColor,
                                                fontSize: fontSizeSmall,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isOverdue)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: paddingSmall,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: errorColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                                borderRadiusSmall),
                                          ),
                                          child: const Text(
                                            'Terlambat',
                                            style: TextStyle(
                                              color: errorColor,
                                              fontSize: fontSizeSmall,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (target.note.isNotEmpty) ...[
                                    const SizedBox(height: paddingSmall),
                                    Text(
                                      target.note,
                                      style: const TextStyle(
                                        fontSize: fontSizeSmall,
                                        color: textColorLight,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: paddingSmall),
                                        Text('Edit'),
                                      ],
                                    ),
                                    onTap: () {
                                      Future.delayed(
                                        Duration(milliseconds: 100),
                                        () => handleEditTarget(target),
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(Icons.delete,
                                            size: 20, color: errorColor),
                                        SizedBox(width: paddingSmall),
                                        Text('Hapus',
                                            style:
                                                TextStyle(color: errorColor)),
                                      ],
                                    ),
                                    onTap: () {
                                      Future.delayed(
                                        Duration(milliseconds: 100),
                                        () => handleDeleteTarget(target.id),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // FLOATING ACTION BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: handleAddTarget,
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: textColorWhite),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigation(
        currentIndex: selectedNavIndex,
        onTap: handleNavigation,
      ),
    );
  }

  // HELPER WIDGET - STAT CARD
  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(paddingSmall),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadiusNormal),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSizeLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSizeSmall,
              color: textColorLight,
            ),
          ),
        ],
      ),
    );
  }
}