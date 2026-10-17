import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/constants/gemini_constants.dart';

class DetectedFoodItem {
  final String name;
  double servingGrams;
  double calories;
  double proteinG;
  double carbsG;
  double fatG;
  final String notes;

  // Nilai per 1 gram dasar agar saat slider digeser bisa dihitung ulang secara akurat
  final double calPerGram;
  final double proteinPerGram;
  final double carbsPerGram;
  final double fatPerGram;

  DetectedFoodItem({
    required this.name,
    required this.servingGrams,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.notes,
    double? calPerGram,
    double? proteinPerGram,
    double? carbsPerGram,
    double? fatPerGram,
  })  : calPerGram = calPerGram ?? (servingGrams > 0 ? calories / servingGrams : 0),
        proteinPerGram = proteinPerGram ?? (servingGrams > 0 ? proteinG / servingGrams : 0),
        carbsPerGram = carbsPerGram ?? (servingGrams > 0 ? carbsG / servingGrams : 0),
        fatPerGram = fatPerGram ?? (servingGrams > 0 ? fatG / servingGrams : 0);

  void updateGrams(double newGrams) {
    servingGrams = newGrams;
    calories = (calPerGram * newGrams).clamp(0, 9999);
    proteinG = (proteinPerGram * newGrams).clamp(0, 999);
    carbsG = (carbsPerGram * newGrams).clamp(0, 999);
    fatG = (fatPerGram * newGrams).clamp(0, 999);
  }

  factory DetectedFoodItem.fromJson(Map<String, dynamic> json) {
    final grams = (json['serving_grams'] as num?)?.toDouble() ?? 100.0;
    final cals = (json['calories'] as num?)?.toDouble() ?? 0.0;
    final p = (json['protein_g'] as num?)?.toDouble() ?? 0.0;
    final c = (json['carbs_g'] as num?)?.toDouble() ?? 0.0;
    final f = (json['fat_g'] as num?)?.toDouble() ?? 0.0;

    return DetectedFoodItem(
      name: json['name'] as String? ?? 'Makanan',
      servingGrams: grams,
      calories: cals,
      proteinG: p,
      carbsG: c,
      fatG: f,
      notes: json['notes'] as String? ?? '',
    );
  }
}

class GeminiFoodService {
  final GenerativeModel _model;

  GeminiFoodService({String? apiKey})
      : _model = GenerativeModel(
          model: GeminiConstants.visionModel,
          apiKey: apiKey ?? GeminiConstants.apiKey,
        );

  /// Menganalisis gambar makanan dan mengembalikan estimasi item, gramasi, dan makro
  Future<List<DetectedFoodItem>> analyzeFoodImage(
    Uint8List imageBytes, {
    String mimeType = 'image/jpeg',
  }) async {
    const prompt = '''
Anda adalah ahli nutrisi dan computer vision untuk aplikasi fitness "IronBite".
Analisis foto piring/makanan ini dengan teliti.

Tugas Anda:
1. Identifikasi setiap item makanan/minuman yang terlihat di piring (termasuk masakan lokal Indonesia maupun internasional).
2. Perkirakan berat/gramasi setiap item berdasarkan estimasi visual porsi normal (misal: 1 centong nasi ~150g, 1 potong dada ayam ~100-120g, 1 butir telur ~55g, 1 tempe goreng ~40g).
3. Hitung perkiraan kalori (kkal), protein (g), karbohidrat (g), dan lemak (g) untuk setiap item sesuai gramasinya.

KEMBALIKAN HANYA JSON MURNI tanpa teks pembuka atau markdown penutup, dengan format persis seperti ini:
[
  {
    "name": "Nasi Putih",
    "serving_grams": 150,
    "calories": 195,
    "protein_g": 4.1,
    "carbs_g": 42.5,
    "fat_g": 0.4,
    "notes": "1 centong nasi sedang"
  }
]
Jika di dalam foto tidak ada makanan, kembalikan array kosong: []
''';

    try {
      final response = await _model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart(mimeType, imageBytes),
        ]),
      ]);

      final text = response.text;
      if (text == null || text.trim().isEmpty) {
        throw Exception('Tidak ada respons teks dari Gemini.');
      }

      // Bersihkan blok markdown ```json ... ``` jika model menyertakannya
      String cleanJson = text.trim();
      if (cleanJson.startsWith('```json')) {
        cleanJson = cleanJson.substring(7);
      } else if (cleanJson.startsWith('```')) {
        cleanJson = cleanJson.substring(3);
      }
      if (cleanJson.endsWith('```')) {
        cleanJson = cleanJson.substring(0, cleanJson.length - 3);
      }
      cleanJson = cleanJson.trim();

      final dynamic decoded = jsonDecode(cleanJson);
      if (decoded is List) {
        return decoded
            .map((item) => DetectedFoodItem.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (decoded is Map<String, dynamic> && decoded.containsKey('items')) {
        final items = decoded['items'] as List;
        return items
            .map((item) => DetectedFoodItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      debugPrint('[GeminiFoodService] Error analyzing food image: $e');
      rethrow;
    }
  }
}

final geminiFoodServiceProvider = Provider<GeminiFoodService>((ref) {
  return GeminiFoodService();
});
