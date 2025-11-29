import '../models/models.dart';

class DataService {
  List<Student> _students = [];
  List<Teacher> _teachers = [];
  List<Course> _courses = [];
  List<Grade> _grades = [];

  List<Student> get students => List.unmodifiable(_students);
  List<Teacher> get teachers => List.unmodifiable(_teachers);
  List<Course> get courses => List.unmodifiable(_courses);
  List<Grade> get grades => List.unmodifiable(_grades);

  DataService() {
    _initializeTestData();
  }

  void _initializeTestData() {
    _teachers = [
      Teacher(
        id: '1',
        name: 'Иван Смирнов',
        email: 'smirnov@university.edu',
        department: 'Математика',
        position: 'Профессор',
        phoneNumber: '+7-999-123-45-67',
        subjects: ['Математический анализ', 'Линейная алгебра'],
        photoUrl: 'https://i.pravatar.cc/150?img=50',
      ),
      Teacher(
        id: '2',
        name: 'Анна Иванова',
        email: 'ivanova@university.edu',
        department: 'Компьютерные науки',
        position: 'Доцент',
        phoneNumber: '+7-999-234-56-78',
        subjects: ['Программирование', 'Алгоритмы'],
        photoUrl: 'https://i.pravatar.cc/150?img=32',
      ),
      Teacher(
        id: '3',
        name: 'Михаил Белов',
        email: 'belov@university.edu',
        department: 'Физика',
        position: 'Преподаватель',
        phoneNumber: '+7-999-345-67-89',
        subjects: ['Общая физика', 'Термодинамика'],
        photoUrl: null,
      ),
    ];

    _students = [
      Student(
        id: '1',
        name: 'Александр Иванов',
        email: 'ivanov@student.edu',
        enrolledCourses: ['1', '2'],
        photoUrl: 'https://i.pravatar.cc/150?img=15',
      ),
      Student(
        id: '2',
        name: 'Елена Петрова',
        email: 'petrova@student.edu',
        enrolledCourses: ['1', '2'],
        photoUrl: 'https://i.pravatar.cc/150?img=5',
      ),
      Student(
        id: '3',
        name: 'Дмитрий Сидоров',
        email: 'sidorov@student.edu',
        enrolledCourses: ['3'],
        photoUrl: null,
      ),
      Student(
        id: '4',
        name: 'Ольга Гусева',
        email: 'guseva@student.edu',
        enrolledCourses: ['2', '3'],
        photoUrl: 'https://i.pravatar.cc/150?img=48',
      ),
    ];

    _courses = [
      Course(
        id: '1',
        name: 'Математический анализ',
        code: 'MATH101',
        credits: 4,
        teacherId: '1',
      ),
      Course(
        id: '2',
        name: 'Программирование',
        code: 'CS101',
        credits: 3,
        teacherId: '2',
      ),
      Course(
        id: '3',
        name: 'Физика',
        code: 'PHYS101',
        credits: 4,
        teacherId: '3',
      ),
    ];

    _grades = [
      Grade(
        id: '1',
        studentId: '1',
        courseId: '1',
        grade: 85,
        date: DateTime(2023, 12, 20),
        comments: 'Хороший результат на экзамене',
      ),
      Grade(
        id: '2',
        studentId: '1',
        courseId: '2',
        grade: 92,
        date: DateTime(2023, 12, 18),
        comments: 'Отличный проект на Flutter',
      ),
      Grade(
        id: '3',
        studentId: '2',
        courseId: '1',
        grade: 78,
        date: DateTime(2023, 12, 20),
        comments: 'Требуется больше практики',
      ),
      Grade(
        id: '4',
        studentId: '2',
        courseId: '2',
        grade: 88,
        date: DateTime(2023, 12, 18),
        comments: 'Хороший результат теста',
      ),
      Grade(
        id: '5',
        studentId: '3',
        courseId: '3',
        grade: 95,
        date: DateTime(2024, 5, 15),
        comments: 'Отличные знания материала',
      ),
    ];
  }

  void addStudent(Student student) {
    _students.add(student);
  }

  void updateStudent(Student student) {
    final index = _students.indexWhere((s) => s.id == student.id);
    if (index != -1) {
      _students[index] = student;
    }
  }

  void deleteStudent(String studentId) {
    _students.removeWhere((s) => s.id == studentId);
    _grades.removeWhere((g) => g.studentId == studentId);
  }

  void addTeacher(Teacher teacher) {
    _teachers.add(teacher);
  }

  void updateTeacher(Teacher teacher) {
    final index = _teachers.indexWhere((t) => t.id == teacher.id);
    if (index != -1) {
      _teachers[index] = teacher;
    }
  }

  void deleteTeacher(String teacherId) {
    _teachers.removeWhere((t) => t.id == teacherId);
    _courses.removeWhere((c) => c.teacherId == teacherId);
  }

  void addCourse(Course course) {
    _courses.add(course);
  }

  void deleteCourse(String courseId) {
    _courses.removeWhere((c) => c.id == courseId);
    _grades.removeWhere((g) => g.courseId == courseId);
    for (var student in _students) {
      student.enrolledCourses.remove(courseId);
    }
  }

  void enrollStudentInCourse(String courseId, String studentId) {
    final student = _students.firstWhere((s) => s.id == studentId, orElse: () => Student(id: '', name: '', email: '', enrolledCourses: []));
    if (student.id.isNotEmpty && !student.enrolledCourses.contains(courseId)) {
      student.enrolledCourses.add(courseId);
    }
  }

  void addGrade(Grade grade) {
    _grades.add(grade);
  }

  void updateGrade(Grade grade) {
    final index = _grades.indexWhere((g) => g.id == grade.id);
    if (index != -1) {
      _grades[index] = grade;
    }
  }

  void deleteGrade(String gradeId) {
    _grades.removeWhere((g) => g.id == gradeId);
  }

  double calculateGPA(String studentId) {
    final studentGrades = _grades.where((g) => g.studentId == studentId).toList();
    if (studentGrades.isEmpty) return 0.0;
    
    double total = 0.0;
    for (var grade in studentGrades) {
      total += _gradeToGPA(grade.grade);
    }
    return total / studentGrades.length;
  }

  double _gradeToGPA(double grade) {
    if (grade >= 90) return 4.0;
    if (grade >= 80) return 3.0;
    if (grade >= 70) return 2.0;
    if (grade >= 60) return 1.0;
    return 0.0;
  }
}