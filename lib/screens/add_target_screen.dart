import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// Halaman untuk menambah target ibadah baru
// Input: Nama target, Kategori, Tanggal Target, Catatan
//  NAVIGASI BERFUNGSI, tapi tombol SIMPAN menampilkan pesan demo

class AddTargetScreen extends StatefulWidget {
  const AddTargetScreen({Key? key}) : super(key: key);

  @override
  State<AddTargetScreen> createState() => _AddTargetScreenState();
}

class _AddTargetScreenState extends State<AddTargetScreen> {
  // 📋 VARIABLES
  late TextEditingController nameController;
  late TextEditingController noteController;
  String selectedCategory = categoryPrayer;
  DateTime selectedDate = DateTime.now(); // TANGGAL TARGET
  bool isLoading = false;
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

  // DATE PICKER
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
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

  // FORMAT TANGGAL
  String _formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ✅ SAVE TARGET FUNCTION - TAMPILKAN PESAN DEMO
  void handleSaveTarget() {
    if (_formKey.currentState!.validate()) {
      // Tampilkan pesan bahwa fitur ini adalah demo
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: warningColor),
              SizedBox(width: paddingSmall),
              Text('Mode Demo'),
            ],
          ),
          content: const Text(
            'Fitur simpan target akan tersedia di versi lengkap aplikasi. '
            'Saat ini Anda sedang menggunakan versi demo dengan data statis dari JSON.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close add target screen
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
        title: const Text(addTargetTitle),
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
                  //  NAMA TARGET INPUT
                  CustomTextField(
                    label: targetName,
                    hint: 'Contoh: Sholat Subuh tepat waktu',
                    controller: nameController,
                    prefixIcon: Icons.task_alt,
                    validator: validateTargetName,
                  ),

                  const SizedBox(height: paddingMedium),

                  //  KATEGORI DROPDOWN
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

                  //  TANGGAL TARGET
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

                  //  CATATAN INPUT (Optional)
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

                  //  CATEGORY PREVIEW
                  Container(
                    padding: const EdgeInsets.all(paddingMedium),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadiusNormal),
                      border: Border.all(color: primaryColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pratinjau Target:',
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
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: paddingSmall,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.circular(borderRadiusSmall),
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
                                borderRadius:
                                    BorderRadius.circular(borderRadiusSmall),
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
                      ],
                    ),
                  ),

                  const SizedBox(height: paddingLarge),

                  //  INFO DEMO MODE
                  Container(
                    padding: const EdgeInsets.all(paddingMedium),
                    decoration: BoxDecoration(
                      color: warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadiusNormal),
                      border: Border.all(color: warningColor),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: warningColor,
                          size: iconSizeNormal,
                        ),
                        SizedBox(width: paddingSmall),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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

                  //  ACTION BUTTONS
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
                          text: saveButton,
                          onPressed: handleSaveTarget,
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