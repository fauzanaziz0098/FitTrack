import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'app_database.dart';

class DefaultFoods {
  static List<LocalFoodsCompanion> get initialFoods {
    final now = DateTime.now();
    const uuid = Uuid();

    final foods = [
      {
        'name': 'Dada Ayam Rebus/Panggang (Tanpa Kulit)',
        'servingSizeG': 100.0,
        'calories': 165.0,
        'protein': 31.0,
        'carbs': 0.0,
        'fat': 3.6,
        'barcode': '899000100001',
      },
      {
        'name': 'Telur Ayam Rebus Utuh',
        'servingSizeG': 50.0, // 1 butir sedang
        'calories': 74.0,
        'protein': 6.3,
        'carbs': 0.4,
        'fat': 5.0,
        'barcode': '899000100002',
      },
      {
        'name': 'Putih Telur Rebus',
        'servingSizeG': 100.0, // ~3 butir putih telur
        'calories': 52.0,
        'protein': 11.0,
        'carbs': 0.7,
        'fat': 0.2,
        'barcode': '899000100003',
      },
      {
        'name': 'Whey Protein Isolate (1 Scoop)',
        'servingSizeG': 30.0,
        'calories': 120.0,
        'protein': 25.0,
        'carbs': 2.0,
        'fat': 1.0,
        'barcode': '899000100004',
      },
      {
        'name': 'Nasi Putih Matang',
        'servingSizeG': 100.0,
        'calories': 130.0,
        'protein': 2.7,
        'carbs': 28.2,
        'fat': 0.3,
        'barcode': '899000100005',
      },
      {
        'name': 'Nasi Merah Matang',
        'servingSizeG': 100.0,
        'calories': 111.0,
        'protein': 2.6,
        'carbs': 23.0,
        'fat': 0.9,
        'barcode': '899000100006',
      },
      {
        'name': 'Daging Sapi Cincang Lean 90/10',
        'servingSizeG': 100.0,
        'calories': 176.0,
        'protein': 26.0,
        'carbs': 0.0,
        'fat': 8.0,
        'barcode': '899000100007',
      },
      {
        'name': 'Ikan Salmon Panggang',
        'servingSizeG': 100.0,
        'calories': 208.0,
        'protein': 22.0,
        'carbs': 0.0,
        'fat': 13.0,
        'barcode': '899000100008',
      },
      {
        'name': 'Ikan Tuna Kaleng (In Water)',
        'servingSizeG': 100.0,
        'calories': 116.0,
        'protein': 26.0,
        'carbs': 0.0,
        'fat': 1.0,
        'barcode': '899000100009',
      },
      {
        'name': 'Tempe Kedelai Kukus/Goreng Airfryer',
        'servingSizeG': 100.0,
        'calories': 192.0,
        'protein': 20.0,
        'carbs': 7.6,
        'fat': 10.8,
        'barcode': '899000100010',
      },
      {
        'name': 'Tahu Putih Segar',
        'servingSizeG': 100.0,
        'calories': 76.0,
        'protein': 8.0,
        'carbs': 1.9,
        'fat': 4.8,
        'barcode': '899000100011',
      },
      {
        'name': 'Oatmeal Instan (Kering)',
        'servingSizeG': 40.0,
        'calories': 150.0,
        'protein': 5.0,
        'carbs': 27.0,
        'fat': 2.5,
        'barcode': '899000100012',
      },
      {
        'name': 'Pisang Cavendish Segar',
        'servingSizeG': 100.0,
        'calories': 89.0,
        'protein': 1.1,
        'carbs': 22.8,
        'fat': 0.3,
        'barcode': '899000100013',
      },
      {
        'name': 'Susu UHT Low Fat',
        'servingSizeG': 200.0, // 200 ml
        'calories': 90.0,
        'protein': 6.0,
        'carbs': 9.0,
        'fat': 3.0,
        'barcode': '899000100014',
      },
      {
        'name': 'Selai Kacang (Peanut Butter)',
        'servingSizeG': 32.0, // 2 sdm
        'calories': 188.0,
        'protein': 8.0,
        'carbs': 6.0,
        'fat': 16.0,
        'barcode': '899000100015',
      },
      {
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
      return LocalFoodsCompanion.insert(
        id: uuid.v4(),
        name: f['name'] as String,
        barcode: Value(f['barcode'] as String?),
        servingSizeG: Value(f['servingSizeG'] as double),
        caloriesPerServing: f['calories'] as double,
        proteinG: Value(f['protein'] as double),
        carbsG: Value(f['carbs'] as double),
        fatG: Value(f['fat'] as double),
        isVerified: const Value(true),
        createdAt: now,
        isSynced: const Value(true),
      );
    }).toList();
  }
}
