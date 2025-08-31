import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_role/services/base_database_service.dart';
import 'package:school_role/services/class_service.dart';

class AttendanceService extends BaseDatabaseService {
  Future<CollectionReference> _attendanceCollection() async {
    final schoolRef = await schoolDoc();
    return schoolRef.collection('attendance');
  }

  Future<void> addAttendance(
      String classID, Map<String, String> records, DateTime timestamp) async {
    final col = await _attendanceCollection();

    final classService = ClassService();
    final classData = await classService.getClassById(classID);
    if (classData == null) throw Exception("Class not found");

    final schedule = Map<String, dynamic>.from(classData['schedule'] ?? {});
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final scheduledDay = weekdays[timestamp.weekday - 1];
    final scheduledPeriod = schedule[scheduledDay] ?? 0;

    await col.add({
      'classID': classID,
      'timestamp': timestamp.toUtc(),
      'schedule': {
        'day': scheduledDay,
        'period': scheduledPeriod,
      },
      'records': records,
    });
  }

  Future<List<Map<String, dynamic>>> getAttendanceForClass(
      String classID) async {
    final col = await _attendanceCollection();
    final snapshot = await col.where('classID', isEqualTo: classID).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
  }
}
