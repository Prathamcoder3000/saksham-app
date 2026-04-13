class MedicineModel {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String instructions;
  final String status; // 'taken', 'pending', etc. (computed for today)

  MedicineModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.instructions,
    required this.status,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      instructions: json['instructions'] ?? '',
      status: json['currentStatus'] ?? 'pending',
    );
  }
}
