import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_database_service.dart';

class ClassService extends BaseDatabaseService {
  Future<List<Map<String, String>>> getClassList(String uID) async {
    final docs = await getDocuments(
      'classes',
      queryBuilder: (q) => q.where('userID', arrayContains: uID).orderBy('order'),
    );

    return docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'] as String? ?? 'Unnamed',
      };
    }).toList();
  }

  Future<void> updateClass(String classId, String name, Map<String, int?> schedule) async {
    final filteredSchedule = Map.fromEntries(
      schedule.entries.where((e) => e.value != null),
    );

    await db.collection('classes').doc(classId).update({
      'name': name,
      'schedule': filteredSchedule,
    });
  }

  Future<DocumentReference> addClass(String name, Map<String, int?> schedule) async {
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    final existing = await getClassList(userId!);

    final data = {
      'name' : name,
      'userID': [userId],
      'order': existing.length,
      'schedule' : Map.fromEntries(
        schedule.entries
          .where((e) => e.value != null)
          .map((e) => MapEntry(e.key, e.value))
      )
    };

    return addDocument('classes', data);
  }

  Future<Map<String, dynamic>?> getClassById(String classId) async {
    final doc = await db.collection('classes').doc(classId).get();

    if (!doc.exists) return null;

    final scheduleData = doc.data()?['schedule'] as Map<String, dynamic>? ?? {};

    return {
      'id': doc.id,
      'name': doc['name'] as String? ?? 'Unnamed',
      'schedule': scheduleData.map((key, value) => MapEntry(key, value as int?)),
      'userID': List<String>.from(doc['userID'] ?? []),
      'order': doc['order'] as int? ?? 0,
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
