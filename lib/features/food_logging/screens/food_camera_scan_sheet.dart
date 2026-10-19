import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/remote/gemini_food_service.dart';
import '../../auth/providers/auth_provider.dart';

class FoodCameraScanSheet extends ConsumerStatefulWidget {
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'

  const FoodCameraScanSheet({
    super.key,
    required this.mealType,
  });

  static Future<void> show(BuildContext context, {required String mealType}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FoodCameraScanSheet(mealType: mealType),
    );
  }

  @override
  ConsumerState<FoodCameraScanSheet> createState() => _FoodCameraScanSheetState();
}

class _FoodCameraScanSheetState extends ConsumerState<FoodCameraScanSheet> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  bool _isAnalyzing = false;
  bool _isSaving = false;
  String? _errorMessage;
  List<DetectedFoodItem> _detectedItems = [];

  String get _mealTypeTitle {
    switch (widget.mealType) {
      case 'breakfast':
        return 'Sarapan';
      case 'lunch':
        return 'Makan Siang';
      case 'dinner':
        return 'Makan Malam';
      case 'snack':
      default:
        return 'Camilan & Suplemen';
    }
  }

  double get _totalCalories =>
      _detectedItems.fold(0, (sum, item) => sum + item.calories);
  double get _totalProtein =>
      _detectedItems.fold(0, (sum, item) => sum + item.proteinG);
  double get _totalCarbs =>
      _detectedItems.fold(0, (sum, item) => sum + item.carbsG);
  double get _totalFat =>
      _detectedItems.fold(0, (sum, item) => sum + item.fatG);

  Future<void> _pickAndAnalyze(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _isAnalyzing = true;
        _errorMessage = null;
        _detectedItems = [];
      });

      final service = ref.read(geminiFoodServiceProvider);
      final items = await service.analyzeFoodImage(bytes, mimeType: file.mimeType ?? 'image/jpeg');

      if (!mounted) return;
      setState(() {
        _detectedItems = items;
        _isAnalyzing = false;
        if (items.isEmpty) {
          _errorMessage = 'Tidak ada makanan yang terdeteksi pada foto. Silakan coba sudut foto yang lebih jelas.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      final errorStr = e.toString().replaceAll('Exception: ', '').replaceAll('GenerativeAIException: ', '');
      setState(() {
        _isAnalyzing = false;
        _errorMessage = 'Gagal menganalisis foto: $errorStr';
      });
    }
  }

  Future<void> _saveAllItems() async {
    if (_detectedItems.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(ironBiteRepositoryProvider);
      final date = ref.read(selectedDateProvider);

      for (final item in _detectedItems) {
        // 1. Daftarkan sebagai custom food di database lokal & remote
        final food = await repo.addCustomFood(
          name: item.name,
          servingSizeG: item.servingGrams,
          caloriesPerServing: item.calories,
          proteinG: item.proteinG,
          carbsG: item.carbsG,
          fatG: item.fatG,
        );

        // 2. Catat ke meal log hari ini
        await repo.logMeal(
          food: food,
          mealType: widget.mealType,
          servingQuantity: 1.0,
          date: date,
        );
      }

      ref.invalidate(mealLogsProvider);
      ref.invalidate(dailySummaryProvider);
      ref.invalidate(foodsListProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            content: Text(
              '${_detectedItems.length} makanan berhasil dicatat via AI Vision ke $_mealTypeTitle!',
              style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.error,
            content: const Text('Gagal mencatat makanan hasil analisis AI.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan Foto Makanan (AI)',
                          style: GoogleFonts.outfit(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Estimasi otomatis ke $_mealTypeTitle',
                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: AppColors.surfaceBorder, height: 1),

          // Content Area
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pick Image Trigger Buttons if not selected yet
                  if (_imageBytes == null && !_isAnalyzing) ...[
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.surfaceBorder, style: BorderStyle.solid),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 56, color: AppColors.primary),
                          const SizedBox(height: 14),
                          Text(
                            'Potret Piring Makanan Anda',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'AI akan otomatis mendeteksi lauk, memperkirakan porsi gramasi, dan menghitung total kalori serta protein.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.camera, color: Colors.black, size: 18),
                                  label: const Text('Buka Kamera'),
                                  onPressed: () => _pickAndAnalyze(ImageSource.camera),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.photo_library, size: 18),
                                  label: const Text('Dari Galeri'),
                                  onPressed: () => _pickAndAnalyze(ImageSource.gallery),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Analyzing State
                  if (_isAnalyzing) ...[
                    if (_imageBytes != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                          _imageBytes!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: AppColors.primary),
                          const SizedBox(height: 16),
                          Text(
                            'AI Sedang Menganalisis Piring Makanan...',
                            style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Memperkirakan berat gramasi dan menghitung nutrisi',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Error Message
                  if (_errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.error, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh, color: Colors.black),
                      label: const Text('Foto Ulang'),
                      onPressed: () => _pickAndAnalyze(ImageSource.camera),
                    ),
                  ],

                  // Results List
                  if (_detectedItems.isNotEmpty && !_isAnalyzing) ...[
                    // Photo thumbnail & Retake option
                    Row(
                      children: [
                        if (_imageBytes != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              _imageBytes!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_detectedItems.length} Makanan Terdeteksi',
                                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              Text(
                                'Geser slider jika ingin mengubah gramasi',
                                style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Foto Ulang',
                          icon: Icon(Icons.flip_camera_ios_outlined, color: AppColors.primary),
                          onPressed: () => _pickAndAnalyze(ImageSource.camera),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Total Macro Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTotalMetric('Total Kalori', '${_totalCalories.round()} kkal', AppColors.primary),
                          _buildTotalMetric('Protein', '${_totalProtein.round()}g', AppColors.protein),
                          _buildTotalMetric('Karbo', '${_totalCarbs.round()}g', AppColors.carbs),
                          _buildTotalMetric('Lemak', '${_totalFat.round()}g', AppColors.fat),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Detected Items Cards
                    ..._detectedItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                      if (item.notes.isNotEmpty)
                                        Text(
                                          item.notes,
                                          style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline, size: 20, color: AppColors.textMuted),
                                  onPressed: () {
                                    setState(() {
                                      _detectedItems.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Gram Slider
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Porsi: ${item.servingGrams.round()} gram',
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                                ),
                                Text(
                                  '${item.calories.round()} kkal  •  P: ${item.proteinG.round()}g  C: ${item.carbsG.round()}g  F: ${item.fatG.round()}g',
                                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                activeTrackColor: AppColors.primary,
                                thumbColor: AppColors.primary,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                              ),
                              child: Slider(
                                value: item.servingGrams.clamp(10.0, 600.0),
                                min: 10.0,
                                max: 600.0,
                                divisions: 118,
                                onChanged: (val) {
                                  setState(() {
                                    item.updateGrams(val);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Save Button
                    ElevatedButton(
                      onPressed: _isSaving ? null : _saveAllItems,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                            )
                          : Text(
                              'Simpan ${_detectedItems.length} Makanan ke $_mealTypeTitle',
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
