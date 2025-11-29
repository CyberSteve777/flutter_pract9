import 'package:flutter/material.dart';
import '../models/grade.dart';
import '../models/student.dart';
import '../models/course.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;
  final Student student;
  final Course course;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const GradeCard({
    super.key,
    required this.grade,
    required this.student,
    required this.course,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getGradeColor(double gradeValue) {
    if (gradeValue >= 90) return Colors.green[700]!;
    if (gradeValue >= 80) return Colors.lightGreen[600]!;
    if (gradeValue >= 70) return Colors.yellow[700]!;
    if (gradeValue >= 60) return Colors.orange[700]!;
    return Colors.red[700]!;
  }

  @override
  Widget build(BuildContext context) {
    final gradeColor = _getGradeColor(grade.grade);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.purple[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: gradeColor,
            child: Text(
              grade.grade.round().toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          title: Text(
            student.name,
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
                  Icon(Icons.book, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(course.name, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 2),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${grade.date.day.toString().padLeft(2, '0')}.${grade.date.month.toString().padLeft(2, '0')}.${grade.date.year}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              if (grade.comments?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    grade.comments ?? '',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
