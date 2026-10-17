import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/local/app_database.dart';
import '../../auth/providers/auth_provider.dart';
import 'create_custom_food_dialog.dart';
import 'food_camera_scan_sheet.dart';

class FoodSearchScreen extends ConsumerStatefulWidget {
  final String mealType; // 'breakfast', 'lunch', 'dinner', 'snack'

  const FoodSearchScreen({super.key, required this.mealType});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _searchController = TextEditingController();

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
        return 'Camilan';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showPortionSheet(LocalFood food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _PortionAdjusterSheet(
        food: food,
        mealType: widget.mealType,
        mealTypeTitle: _mealTypeTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final foodsAsync = ref.watch(foodsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Makanan', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              'Untuk $_mealTypeTitle',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Scan Foto Makanan (AI)',
            icon: Icon(Icons.camera_alt_outlined, color: AppColors.primary),
            onPressed: () => FoodCameraScanSheet.show(context, mealType: widget.mealType),
          ),
          IconButton(
            tooltip: 'Tambah Custom Food',
            icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () async {
              final created = await showDialog<LocalFood?>(
                context: context,
                builder: (_) => const CreateCustomFoodDialog(),
              );
              if (created != null && mounted) {
                _showPortionSheet(created);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(foodSearchQueryProvider.notifier).setQuery(val);
              },
              decoration: InputDecoration(
                hintText: 'Cari makanan (ayam, telur, whey, dll)...',
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(foodSearchQueryProvider.notifier).clear();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Foods List
          Expanded(
            child: foodsAsync.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (_, _) => Center(
                child: Text('Gagal memuat daftar makanan.', style: TextStyle(color: AppColors.error)),
              ),
              data: (foods) {
                if (foods.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'Makanan tidak ditemukan',
                            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Buat makanan kustom jika menu Anda belum terdaftar.',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, color: Colors.black),
                            label: const Text('Buat Makanan Kustom'),
                            onPressed: () async {
                              final created = await showDialog<LocalFood?>(
                                context: context,
                                builder: (_) => const CreateCustomFoodDialog(),
                              );
                              if (created != null && mounted) {
                                _showPortionSheet(created);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: foods.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return InkWell(
                      onTap: () => _showPortionSheet(food),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.surfaceBorder),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          food.name,
                                          style: GoogleFonts.inter(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (food.isVerified) ...[
                                        const SizedBox(width: 6),
                                        Icon(Icons.verified, size: 16, color: AppColors.primary),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Porsi: ${food.servingSizeG.round()}g • P: ${food.proteinG.round()}g  C: ${food.carbsG.round()}g  F: ${food.fatG.round()}g',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${food.caloriesPerServing.round()} kkal',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Icon(Icons.add_circle_outline, size: 18, color: AppColors.textMuted),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PortionAdjusterSheet extends ConsumerStatefulWidget {
  final LocalFood food;
  final String mealType;
  final String mealTypeTitle;

  const _PortionAdjusterSheet({
    required this.food,
    required this.mealType,
    required this.mealTypeTitle,
  });

  @override
  ConsumerState<_PortionAdjusterSheet> createState() => _PortionAdjusterSheetState();
}

class _PortionAdjusterSheetState extends ConsumerState<_PortionAdjusterSheet> {
  double _quantity = 1.0; // Multiplier (e.g. 1.0 = 100g)
  bool _isLoading = false;

  final List<double> _presetMultipliers = [0.5, 1.0, 1.5, 2.0, 2.5, 3.0];

  double get _currentGrams => widget.food.servingSizeG * _quantity;
  double get _totalCalories => widget.food.caloriesPerServing * _quantity;
  double get _totalProtein => widget.food.proteinG * _quantity;
  double get _totalCarbs => widget.food.carbsG * _quantity;
  double get _totalFat => widget.food.fatG * _quantity;

  Future<void> _logMeal() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(ironBiteRepositoryProvider);
      final date = ref.read(selectedDateProvider);

      await repo.logMeal(
        food: widget.food,
        mealType: widget.mealType,
        servingQuantity: _quantity,
        date: date,
      );

      if (mounted) {
        Navigator.pop(context); // Close bottom sheet
        Navigator.pop(context); // Return to Dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primary,
            content: Text(
              '${widget.food.name} (${_totalCalories.round()} kkal) dicatat ke ${widget.mealTypeTitle}!',
              style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: AppColors.error, content: const Text('Gagal mencatat makanan.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title & Base Serving
          Text(
            widget.food.name,
            style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'Target Waktu Makan: ${widget.mealTypeTitle}',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary),
          ),
          const SizedBox(height: 20),

          // Dynamic Portion Multiplier Selection
          Text('Jumlah Porsi / Gramasi', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _presetMultipliers.map((mult) {
                final isSelected = (_quantity - mult).abs() < 0.01;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text('${mult}x (${(widget.food.servingSizeG * mult).round()}g)'),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surfaceLight,
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black : AppColors.textPrimary,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _quantity = mult);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Fine Adjustment Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Porsi Presisi: ${_quantity.toStringAsFixed(1)}x',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
              ),
              Text(
                '${_currentGrams.round()} gram',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: AppColors.primary,
              thumbColor: AppColors.primary,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: _quantity.clamp(0.1, 5.0),
              min: 0.1,
              max: 5.0,
              divisions: 49,
              onChanged: (val) => setState(() => _quantity = val),
            ),
          ),
          const SizedBox(height: 16),

          // Live Nutrients Breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroMetric('Kalori', '${_totalCalories.round()} kkal', AppColors.primary),
                _buildMacroMetric('Protein', '${_totalProtein.toStringAsFixed(1)}g', AppColors.protein),
                _buildMacroMetric('Karbo', '${_totalCarbs.toStringAsFixed(1)}g', AppColors.carbs),
                _buildMacroMetric('Lemak', '${_totalFat.toStringAsFixed(1)}g', AppColors.fat),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Confirm Button
          ElevatedButton(
            onPressed: _isLoading ? null : _logMeal,
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                  )
                : Text(
                    'Catat ke ${widget.mealTypeTitle}',
                    style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
