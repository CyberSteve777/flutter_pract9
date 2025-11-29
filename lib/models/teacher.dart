class Teacher {
  final String id;
  final String name;
  final String email;
  final String department;
  final String position;
  final String phoneNumber;
  final List<String> subjects;
  final String? photoUrl;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.position,
    required this.phoneNumber,
    required this.subjects,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'position': position,
      'phoneNumber': phoneNumber,
      'subjects': subjects,
      'photoUrl': photoUrl,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      department: map['department'],
      position: map['position'],
      phoneNumber: map['phoneNumber'],
      subjects: List<String>.from(map['subjects'] ?? []),
      photoUrl: map['photoUrl'],
    );
  }
}