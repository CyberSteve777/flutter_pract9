class Grade {
  final String id;
  final String studentId;
  final String courseId;
  final double grade;
  final DateTime date;
  final String? comments;

  Grade({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.grade,
    required this.date,
    this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'grade': grade,
      'date': date.toIso8601String(),
      'comments': comments,
    };
  }

  factory Grade.fromMap(Map<String, dynamic> map) {
    return Grade(
      id: map['id'],
      studentId: map['studentId'],
      courseId: map['courseId'],
      grade: map['grade'].toDouble(),
      date: DateTime.parse(map['date']),
      comments: map['comments'],
    );
  }
}