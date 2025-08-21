import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_database_service.dart';

class ClassService extends BaseDatabaseService {
  Future<List<Map<String, String>>> getClassList(String uID) async {
    final docs = await getDocuments(
      'classes',
      queryBuilder: (q) =>
          q.where('userID', arrayContains: uID).orderBy('order'),
    );

    return docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>? ?? {};
      final name = data['name'];
      return {
        'id': doc.id,
        'name': name is String ? name : 'Unnamed',
      };
    }).toList();
  }

  Future<void> updateClass(
      String classId, String name, Map<String, int?> schedule) async {
    final filteredSchedule =
        Map.fromEntries(schedule.entries.where((e) => e.value != null));

    await db.collection('classes').doc(classId).update({
      'name': name,
      'schedule': filteredSchedule,
    });
  }

  Future<DocumentReference> addClass(
      String name, Map<String, int?> schedule) async {
    final currentUserId = userId; 
    if (currentUserId == null) {
      throw Exception("User not authenticated");
    }

    final existing = await getClassList(userId!);

    final safeSchedule = Map.fromEntries(
      schedule.entries.where((e) => e.value != null).map(
            (e) => MapEntry(e.key, e.value),
          ),
    );

    final data = {
      'name': name,
      'userID': [currentUserId],
      'order': existing.length,
      'schedule': safeSchedule,
    };

    return addDocument('classes', data);
  }

  Future<Map<String, dynamic>?> getClassById(String classId) async {
    final doc = await db.collection('classes').doc(classId).get();
    if (!doc.exists) return null;

    final data = doc.data() ?? {};

    final scheduleData = data['schedule'];
    final safeSchedule = scheduleData is Map<String, dynamic>
        ? scheduleData.map((k, v) => MapEntry(k, v is int ? v : null))
        : {};

    final rawUserID = data['userID'];
    final safeUserIDs =
        rawUserID is List ? List<String>.from(rawUserID) : <String>[];

    return {
      'id': doc.id,
      'name': data['name'] is String ? data['name'] as String : 'Unnamed',
      'schedule': safeSchedule,
      'userID': safeUserIDs,
      'order': data['order'] is int ? data['order'] as int : 0,
    };
  }

  Future<void> reorderClasses(List<dynamic> classIds) async {
    final batch = db.batch();
    for (int i = 0; i < classIds.length; i++) {
      final docRef = db.collection('classes').doc(classIds[i]);
      batch.update(docRef, {'order': i});
    }
    await batch.commit();
  }

  Future<void> deleteClass(String classId) async {
    await deleteDocument('classes', classId);
  }
}
