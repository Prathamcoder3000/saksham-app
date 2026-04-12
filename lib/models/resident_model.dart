class ResidentModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String room;
  final List<String> conditions;
  final List<String> allergies;
  final String contactName;
  final String contactPhone;
  final String? photoUrl;
  final String? assignedCaretaker;
  final String? admissionDate;

  ResidentModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.room,
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
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? 'Other',
      room: json['room'] ?? '',
      conditions: List<String>.from(json['conditions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      contactName: json['emergencyContactName'] ?? '',
      contactPhone: json['emergencyContactPhone'] ?? '',
      photoUrl: json['photoUrl'],
      assignedCaretaker: json['assignedCaretaker'] is Map 
          ? json['assignedCaretaker']['_id'] 
          : json['assignedCaretaker'],
      admissionDate: json['admissionDate'],
    );
  }
}
