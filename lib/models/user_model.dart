class UserModel {
  final String id;
  final String email;
  final String? name;
  final String role;
  
  UserModel({
    required this.id,
    required this.email,
    this.name,
    required this.role,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'] ?? 'trainer',
    );
  }
}
