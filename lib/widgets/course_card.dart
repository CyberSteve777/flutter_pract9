import 'package:flutter/material.dart';
import '../utils/ru_plural.dart';
import '../models/course.dart';
import '../models/teacher.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final Teacher teacher;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onEnrollStudent;

  const CourseCard({
    super.key,
    required this.course,
    required this.teacher,
    required this.onEdit,
    required this.onDelete,
    required this.onEnrollStudent,
  });

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.green[300]!,
          width: 2,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: Colors.green[700],
            child: Icon(
              Icons.school,
              color: Colors.white,
              size: 24,
            ),
          ),
          title: Text(
            course.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.code, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(course.code, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(teacher.name, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(formatCount(course.credits, 'час', 'часа', 'часов'), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.person_add, color: Colors.blue),
                onPressed: onEnrollStudent,
                tooltip: 'Записать студента',
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
