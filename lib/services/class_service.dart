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
    }
  ).toList();
}

  Future<DocumentReference> addClass(String name) async {
    if (userId == null) {
      throw Exception("User not authenticated");
    }

    final existing = await getClassList(userId!);

    final data = {
      'name' : name,
      'userID': [userId],
      'order': existing.length,
    };

    return addDocument('classes', data);
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
