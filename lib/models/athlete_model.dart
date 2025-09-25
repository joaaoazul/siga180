class Athlete {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String status;
  final DateTime createdAt;
  
  Athlete({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.status,
    required this.createdAt,
  });
  
  factory Athlete.fromJson(Map<String, dynamic> json) {
    return Athlete(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
