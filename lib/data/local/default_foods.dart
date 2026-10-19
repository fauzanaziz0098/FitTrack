import 'package:uuid/uuid.dart';
import '../models/food_item.dart';

class DefaultFoods {
  static List<FoodItem> get initialFoods {
    final now = DateTime.now();
    const uuid = Uuid();

    final foods = [
      {
        'id': 'df-001',
        'name': 'Dada Ayam Rebus/Panggang (Tanpa Kulit)',
        'servingSizeG': 100.0,
        'calories': 165.0,
        'protein': 31.0,
        'carbs': 0.0,
        'fat': 3.6,
        'barcode': '899000100001',
      },
      {
        'id': 'df-002',
        'name': 'Telur Ayam Rebus Utuh',
        'servingSizeG': 50.0, // 1 butir sedang
        'calories': 74.0,
        'protein': 6.3,
        'carbs': 0.4,
        'fat': 5.0,
        'barcode': '899000100002',
      },
      {
        'id': 'df-003',
        'name': 'Putih Telur Rebus',
        'servingSizeG': 100.0, // ~3 butir putih telur
        'calories': 52.0,
        'protein': 11.0,
        'carbs': 0.7,
        'fat': 0.2,
        'barcode': '899000100003',
      },
      {
        'id': 'df-004',
        'name': 'Whey Protein Isolate (1 Scoop)',
        'servingSizeG': 30.0,
        'calories': 120.0,
        'protein': 25.0,
        'carbs': 2.0,
        'fat': 1.0,
        'barcode': '899000100004',
      },
      {
        'id': 'df-005',
        'name': 'Nasi Putih Matang',
        'servingSizeG': 100.0,
        'calories': 130.0,
        'protein': 2.7,
        'carbs': 28.2,
        'fat': 0.3,
        'barcode': '899000100005',
      },
      {
        'id': 'df-006',
        'name': 'Nasi Merah Matang',
        'servingSizeG': 100.0,
        'calories': 111.0,
        'protein': 2.6,
        'carbs': 23.0,
        'fat': 0.9,
        'barcode': '899000100006',
      },
      {
        'id': 'df-007',
        'name': 'Daging Sapi Cincang Lean 90/10',
        'servingSizeG': 100.0,
        'calories': 176.0,
        'protein': 26.0,
        'carbs': 0.0,
        'fat': 8.0,
        'barcode': '899000100007',
      },
      {
        'id': 'df-008',
        'name': 'Ikan Salmon Panggang',
        'servingSizeG': 100.0,
        'calories': 208.0,
        'protein': 22.0,
        'carbs': 0.0,
        'fat': 13.0,
        'barcode': '899000100008',
      },
      {
        'id': 'df-009',
        'name': 'Ikan Tuna Kaleng (In Water)',
        'servingSizeG': 100.0,
        'calories': 116.0,
        'protein': 26.0,
        'carbs': 0.0,
        'fat': 1.0,
        'barcode': '899000100009',
      },
      {
        'id': 'df-010',
        'name': 'Tempe Kedelai Kukus/Goreng Airfryer',
        'servingSizeG': 100.0,
        'calories': 192.0,
        'protein': 20.0,
        'carbs': 7.6,
        'fat': 10.8,
        'barcode': '899000100010',
      },
      {
        'id': 'df-011',
        'name': 'Tahu Putih Segar',
        'servingSizeG': 100.0,
        'calories': 76.0,
        'protein': 8.0,
        'carbs': 1.9,
        'fat': 4.8,
        'barcode': '899000100011',
      },
      {
        'id': 'df-012',
        'name': 'Oatmeal Instan (Kering)',
        'servingSizeG': 40.0,
        'calories': 150.0,
        'protein': 5.0,
        'carbs': 27.0,
        'fat': 2.5,
        'barcode': '899000100012',
      },
      {
        'id': 'df-013',
        'name': 'Pisang Cavendish Segar',
        'servingSizeG': 100.0,
        'calories': 89.0,
        'protein': 1.1,
        'carbs': 22.8,
        'fat': 0.3,
        'barcode': '899000100013',
      },
      {
        'id': 'df-014',
        'name': 'Susu UHT Low Fat',
        'servingSizeG': 200.0, // 200 ml
        'calories': 90.0,
        'protein': 6.0,
        'carbs': 9.0,
        'fat': 3.0,
        'barcode': '899000100014',
      },
      {
        'id': 'df-015',
        'name': 'Selai Kacang (Peanut Butter)',
        'servingSizeG': 32.0, // 2 sdm
        'calories': 188.0,
        'protein': 8.0,
        'carbs': 6.0,
        'fat': 16.0,
        'barcode': '899000100015',
      },
      {
        'id': 'df-016',
        'name': 'Brokoli Kukus',
        'servingSizeG': 100.0,
        'calories': 35.0,
        'protein': 2.4,
        'carbs': 7.2,
        'fat': 0.4,
        'barcode': '899000100016',
      },
    ];

    return foods.map((f) {
      return FoodItem(
        id: f['id'] as String? ?? uuid.v4(),
        name: f['name'] as String,
        barcode: f['barcode'] as String?,
        servingSizeG: (f['servingSizeG'] as num).toDouble(),
        caloriesPerServing: (f['calories'] as num).toDouble(),
        proteinG: (f['protein'] as num).toDouble(),
        carbsG: (f['carbs'] as num).toDouble(),
        fatG: (f['fat'] as num).toDouble(),
        isVerified: true,
        createdAt: now,
      );
    }).toList();
  }
}
