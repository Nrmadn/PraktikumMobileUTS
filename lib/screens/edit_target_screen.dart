import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/target_ibadah_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Halaman untuk mengedit target ibadah yang sudah ada
// Input: Nama target, Kategori, Tanggal Target, Catatan (dari argument)
// ✅ NAVIGASI BERFUNGSI, tapi tombol UPDATE menampilkan pesan demo

class EditTargetScreen extends StatefulWidget {
  const EditTargetScreen({Key? key}) : super(key: key);

  @override
  State<EditTargetScreen> createState() => _EditTargetScreenState();
}

class _EditTargetScreenState extends State<EditTargetScreen> {
  // 📋 VARIABLES
  late TextEditingController nameController;
  late TextEditingController noteController;
  late TargetIbadah targetData;
  String selectedCategory = categoryPrayer;
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;
  bool dataLoaded = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> categories = [
    categoryPrayer,
    categoryQuran,
    categoryCharity,
    categoryZikir,
    categoryOther,
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    noteController = TextEditingController();
    
    // Ambil data dari arguments (dikirim dari Progress Home Screen)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is TargetIbadah) {
        setState(() {
          targetData = args;
          nameController.text = targetData.name;
          noteController.text = targetData.note;
          selectedCategory = targetData.category;
          selectedDate = targetData.targetDate;
          dataLoaded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    noteController.dispose();
    super.dispose();
  }

  // VALIDATOR FUNGSI
  String? validateTargetName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama target tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Nama target minimal 3 karakter';
    }
    return null;
  }

  // 📅 DATE PICKER
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: textColorWhite,
              onSurface: textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // 📅 FORMAT TANGGAL
  String _formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ✅ UPDATE TARGET FUNCTION - TAMPILKAN PESAN DEMO
  void handleUpdateTarget() {
    if (_formKey.currentState!.validate()) {
      // Tampilkan pesan bahwa fitur ini adalah demo
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.info_outline, color: warningColor),
              SizedBox(width: paddingSmall),
              Text('Mode Demo'),
            ],
          ),
          content: const Text(
            'Fitur update target akan tersedia di versi lengkap aplikasi. '
            'Saat ini Anda sedang menggunakan versi demo dengan data statis dari JSON.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close edit target screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(editTargetTitle),
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 📝 NAMA TARGET INPUT
                  CustomTextField(
                    label: targetName,
                    hint: 'Masukkan nama target',
                    controller: nameController,
                    prefixIcon: Icons.task_alt,
                    validator: validateTargetName,
                  ),

                  const SizedBox(height: paddingMedium),

                  // 🎯 KATEGORI DROPDOWN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        targetCategory,
                        style: TextStyle(
                          fontSize: fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: paddingSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: paddingMedium,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius:
                              BorderRadius.circular(borderRadiusNormal),
                          color: cardBackgroundColor,
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedCategory,
                          underline: const SizedBox(),
                          items: categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue ?? categoryPrayer;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: paddingMedium),

                  // 📅 TANGGAL TARGET
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tanggal Target',
                        style: TextStyle(
                          fontSize: fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: paddingSmall),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.all(paddingMedium),
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            borderRadius:
                                BorderRadius.circular(borderRadiusNormal),
                            color: cardBackgroundColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: primaryColor,
                                    size: iconSizeNormal,
                                  ),
                                  const SizedBox(width: paddingNormal),
                                  Text(
                                    _formatDate(selectedDate),
                                    style: const TextStyle(
                                      fontSize: fontSizeNormal,
                                      color: textColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: textColorLight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: paddingMedium),

                  // 📝 CATATAN INPUT (Optional)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        targetNote,
                        style: TextStyle(
                          fontSize: fontSizeMedium,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: paddingSmall),
                      TextField(
                        controller: noteController,
                        maxLines: 3,
                        minLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: cardBackgroundColor,
                          hintText: 'Tambahkan catatan (opsional)',
                          hintStyle: const TextStyle(
                            color: textColorLighter,
                          ),
                          contentPadding: const EdgeInsets.all(paddingMedium),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(borderRadiusNormal),
                            borderSide: const BorderSide(color: borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(borderRadiusNormal),
                            borderSide: const BorderSide(color: borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(borderRadiusNormal),
                            borderSide: const BorderSide(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: paddingLarge),

                  // 👁️ INFORMASI TARGET
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
                          'Informasi Target:',
                          style: TextStyle(
                            fontSize: fontSizeNormal,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: paddingSmall),
                        Text(
                          nameController.text.isEmpty
                              ? 'Nama target akan muncul di sini'
                              : nameController.text,
                          style: const TextStyle(
                            fontSize: fontSizeMedium,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: paddingSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
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
                                    selectedCategory,
                                    style: const TextStyle(
                                      color: textColorWhite,
                                      fontSize: fontSizeSmall,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: paddingSmall),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: paddingSmall,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(
                                        borderRadiusSmall),
                                    border: Border.all(color: accentColor),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 12,
                                        color: accentColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatDate(selectedDate),
                                        style: const TextStyle(
                                          color: textColor,
                                          fontSize: fontSizeSmall,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (dataLoaded)
                              Text(
                                'ID: ${targetData.id}',
                                style: const TextStyle(
                                  fontSize: fontSizeSmall,
                                  color: textColorLight,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: paddingLarge),

                  // ⚠️ INFO DEMO MODE
                  Container(
                    padding: const EdgeInsets.all(paddingMedium),
                    decoration: BoxDecoration(
                      color: warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadiusNormal),
                      border: Border.all(color: warningColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: warningColor,
                          size: iconSizeNormal,
                        ),
                        const SizedBox(width: paddingSmall),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Mode Demo',
                                style: TextStyle(
                                  fontSize: fontSizeNormal,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Data akan tersedia di versi lengkap',
                                style: TextStyle(
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

                  const SizedBox(height: paddingLarge),

                  // 🔘 ACTION BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedCustomButton(
                          text: cancelButton,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: paddingNormal),
                      Expanded(
                        child: CustomButton(
                          text: updateButton,
                          onPressed: handleUpdateTarget,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: paddingMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}