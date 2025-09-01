import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_role/services/base_database_service.dart';
import 'package:school_role/services/class_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';

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

  Future<void> addAttendanceForDay({
    required String classID,
    required String schoolID,
    required Map<String, String> records,
    required String selectedDay,
    required int selectedPeriod,
  }) async {
    final col = await _attendanceCollection();

    await col.add({
      'classID': classID,
      'timestamp': FieldValue.serverTimestamp(),
      'schedule': {
        'day': selectedDay,
        'period': selectedPeriod,
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
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> exportAttendanceAsJson({
    required String className,
    required String selectedDay,
    required int selectedPeriod,
    required Map<String, String> records,
  }) async {
    final timeStamp = DateTime.now().toIso8601String();
    final attendanceData = {
      'className': className,
      'date': timeStamp,
      'day': selectedDay,
      'period': selectedPeriod,
      'records': records,
    };

    final jsonString = jsonEncode(attendanceData);
    final fileName = 'attendance_$className.json';
    final mimeType = MimeType.json;
    final bytes = utf8.encode(jsonString);

    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        fileExtension: '.json',
        mimeType: mimeType,
      );
    } else {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        await FileSaver.instance.saveFile(
          name: fileName,
          bytes: bytes,
          fileExtension: '.json',
          mimeType: mimeType,
        );
      } else if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(jsonString);
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path)],
            subject: 'Attendance Data',
            text: 'Attendance for $className on $selectedDay (Period $selectedPeriod) $timeStamp',
          ),
        );
      }
    }
  }
}