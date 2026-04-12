class TaskModel {
  final String id;
  final String title;
  final String description;
  final String status;
  final String date;
  final String residentName;
  final String residentRoom;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.date,
    required this.residentName,
    required this.residentRoom,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      date: json['date'] ?? '',
      residentName: json['resident'] is Map ? json['resident']['name'] : 'Unknown',
      residentRoom: json['resident'] is Map ? json['resident']['room'] : 'N/A',
    );
  }
}
