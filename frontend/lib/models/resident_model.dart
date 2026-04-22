class ResidentModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String room;
  final String status;
  final List<String> conditions;
  final List<String> allergies;
  final String? contactName;
  final String? contactPhone;
  final String? photoUrl;
  final String? assignedCaretaker;
  final String? admissionDate;

  ResidentModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.room,
    required this.status,
    required this.conditions,
    required this.allergies,
    required this.contactName,
    required this.contactPhone,
    this.photoUrl,
    this.assignedCaretaker,
    this.admissionDate,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json) {
    return ResidentModel(
      id: (json['_id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      age: int.tryParse(json['age']?.toString() ?? '') ?? 0,
      gender: (json['gender'] ?? 'Other') as String,
      room: (json['room'] ?? '') as String,
      status: (json['status'] ?? 'Stable') as String,
      conditions: List<String>.from(json['conditions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      contactName: (json['emergencyContactName'] ?? '') as String,
      contactPhone: (json['emergencyContactPhone'] ?? '') as String,
      photoUrl: json['photoUrl'] as String?,
      assignedCaretaker: json['assignedCaretaker'] is Map 
          ? (json['assignedCaretaker']['_id'] as String?)
          : (json['assignedCaretaker'] as String?),
      admissionDate: json['admissionDate'] as String?,
    );
  }
}
