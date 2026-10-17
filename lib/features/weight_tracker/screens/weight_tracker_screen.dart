import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/local/app_database.dart';
import '../../auth/providers/auth_provider.dart';

class WeightTrackerScreen extends ConsumerStatefulWidget {
  const WeightTrackerScreen({super.key});

  @override
  ConsumerState<WeightTrackerScreen> createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends ConsumerState<WeightTrackerScreen> {
  void _openAddWeightDialog([LocalWeightLog? existingLog]) {
    final weightController = TextEditingController(
      text: existingLog != null ? existingLog.weightKg.toString() : '',
    );
    final notesController = TextEditingController(
      text: existingLog?.notes ?? '',
    );
    DateTime selectedDate = existingLog?.loggedDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.surfaceBorder),
          ),
          title: Text(
            existingLog != null ? 'Edit Timbangan' : 'Catat Berat Badan',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date picker trigger
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (c, child) => Theme(
                        data: Theme.of(c).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: AppColors.primary,
                            onPrimary: Colors.black,
                            surface: AppColors.surface,
                            onSurface: AppColors.textPrimary,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('d MMMM yyyy').format(selectedDate),
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary),
                        ),
                        const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Weight Input
                TextField(
                  controller: weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Berat Badan (kg)',
                    hintText: '72.5',
                    suffixText: 'kg',
                  ),
                ),
                const SizedBox(height: 14),

                // Notes
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan (Opsional)',
                    hintText: 'Perut kosong setelah bangun tidur',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final weight = double.tryParse(weightController.text);
                if (weight == null || weight <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.error,
                      content: Text('Masukkan angka berat badan yang valid'),
                    ),
                  );
                  return;
                }

                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(ctx);
                await ref.read(ironBiteRepositoryProvider).logWeight(
                  weightKg: weight,
                  date: selectedDate,
                  notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                );

                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text(
                        'Berat ${weight}kg berhasil dicatat!',
                        style: GoogleFonts.outfit(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final weightLogsAsync = ref.watch(weightLogsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Weight Tracker', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: 'Tambah Data Timbangan',
            icon: const Icon(Icons.add_circle, color: AppColors.primary),
            onPressed: () => _openAddWeightDialog(),
          ),
        ],
      ),
      body: weightLogsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: AppColors.error)),
        ),
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monitor_weight_outlined, size: 64, color: AppColors.textMuted),
                    const SizedBox(height: 16),
                    Text(
                      'Belum Ada Catatan Berat Badan',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Timbang badan secara konsisten di pagi hari untuk melihat tren kenaikan otot atau penurunan lemak.',
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: const Text('Catat Berat Sekarang'),
                      onPressed: () => _openAddWeightDialog(),
                    ),
                  ],
                ),
              ),
            );
          }

          final currentWeight = logs.last.weightKg;
          final startWeight = logs.first.weightKg;
          final diff = currentWeight - startWeight;
          final minWeight = logs.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
          final maxWeight = logs.map((e) => e.weightKg).reduce((a, b) => a > b ? a : b);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Stats Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricItem(
                        'Saat Ini',
                        '${currentWeight.toStringAsFixed(1)} kg',
                        AppColors.primary,
                      ),
                      Container(width: 1, height: 35, color: AppColors.surfaceBorder),
                      _buildMetricItem(
                        'Perubahan',
                        '${diff >= 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg',
                        diff >= 0 ? AppColors.accentOrange : AppColors.accentBlue,
                      ),
                      Container(width: 1, height: 35, color: AppColors.surfaceBorder),
                      _buildMetricItem(
                        'Rentang (Min-Max)',
                        '${minWeight.toStringAsFixed(1)} - ${maxWeight.toStringAsFixed(1)}',
                        AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Interactive Weight Trend Chart
                Container(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 10, bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, bottom: 16.0),
                        child: Text(
                          'Tren Fluktuasi Berat Badan',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 220,
                        child: _buildWeightLineChart(logs),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // History Log List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat Penimbangan',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${logs.length} entri',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // List items in reverse order (newest first)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final log = logs.reversed.toList()[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.monitor_weight_outlined, size: 18, color: AppColors.primary),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEEE, d MMMM yyyy').format(log.loggedDate),
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                                if (log.notes != null && log.notes!.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      log.notes!,
                                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            '${log.weightKg.toStringAsFixed(1)} kg',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: AppColors.surfaceLight,
                                  title: const Text('Hapus Catatan?'),
                                  content: Text('Hapus timbangan tanggal ${DateFormat('d MMM yyyy').format(log.loggedDate)}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await ref.read(ironBiteRepositoryProvider).deleteWeightLog(log.id);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildWeightLineChart(List<LocalWeightLog> logs) {
    final spots = <FlSpot>[];
    for (int i = 0; i < logs.length; i++) {
      spots.add(FlSpot(i.toDouble(), logs[i].weightKg));
    }

    final weights = logs.map((e) => e.weightKg).toList();
    final minY = (weights.reduce((a, b) => a < b ? a : b) - 2).floorToDouble();
    final maxY = (weights.reduce((a, b) => a > b ? a : b) + 2).ceilToDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (logs.length - 1).toDouble().clamp(0.0, 100.0),
        minY: minY,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 2,
          getDrawingHorizontalLine: (val) => FlLine(
            color: AppColors.surfaceBorder.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              interval: 2,
              getTitlesWidget: (val, meta) => Text(
                '${val.round()}kg',
                style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (logs.length / 4).ceilToDouble().clamp(1.0, 10.0),
              getTitlesWidget: (val, meta) {
                final index = val.toInt();
                if (index < 0 || index >= logs.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    DateFormat('d/M').format(logs[index].loggedDate),
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.25,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.black,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.25),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
