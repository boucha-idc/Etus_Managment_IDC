import 'dart:convert';

class User {
  String name;
  String email;
  String password;
  String phoneNumber;
  String recruitmentDate;
  String role;
  int specialtyId;
  String image;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.recruitmentDate,
    required this.role,
    required this.specialtyId,
    this.image = '', // Default empty string for image if not provided
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '', // Default to empty string if value is missing
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      recruitmentDate: json['recruitment_date'] ?? '',
      role: json['role'] ?? '',
      specialtyId: json['specialty_id'] ?? 0, // Default to 0 if missing
      image: json['image'] ?? '', // Default to empty string if image is missing
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'recruitment_date': recruitmentDate,
      'role': role,
      'specialty_id': specialtyId,
      'image': image, // Add image to the JSON
    };
  }

  // Optional: You can create a method to display the User info as a string (useful for debugging)
  @override
  String toString() {
    return 'User(name: $name, email: $email, phoneNumber: $phoneNumber, recruitmentDate: $recruitmentDate, role: $role, specialtyId: $specialtyId, image: $image)';
  }
}
