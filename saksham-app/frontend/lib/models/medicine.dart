class Medicine {
  String name;
  String dose;
  String time;
  String status; // taken, pending, missed, upcoming

  Medicine({
    required this.name,
    required this.dose,
    required this.time,
    required this.status,
  });
}