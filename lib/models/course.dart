class Course {
  final String id;
  final String name;
  final String code;
  final int credits;
  final String teacherId;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.credits,
    required this.teacherId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'credits': credits,
      'teacherId': teacherId,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      credits: map['credits'],
      teacherId: map['teacherId'],
    );
  }
}