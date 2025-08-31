import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_database_service.dart';

class ClassService extends BaseDatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<CollectionReference> get _classesCollection async {
    final schoolID = await schoolId;
    return _firestore.collection('schools').doc(schoolID).collection('classes');
  }

  Future<void> addStudentToClass(
      {required String schoolID, required String classID, required String studentID}) async {
    final docRef =
        _firestore.collection('schools').doc(schoolID).collection('classes').doc(classID);

    await docRef.update({
      'studentIDs.$studentID': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<String>> getClassStudentIDs(String schoolID, String classID) async {
    final doc =
        await _firestore.collection('schools').doc(schoolID).collection('classes').doc(classID).get();

    if (!doc.exists || doc.data()?['studentIDs'] == null) return [];

    return (doc.data()!['studentIDs'] as Map<String, dynamic>).keys.toList();
  }

  Stream<List<Map<String, dynamic>>> streamClassList() async* {
    final col = await _classesCollection;
    yield* col.orderBy('order', descending: false).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unnamed',
          'schedule': data['schedule'] ?? {},
          'order': data['order'] ?? 0,
          'teacherID': data['teacherID'] ?? '',
          'createdAt': data['createdAt'],
        };
      }).toList();
    });
  }

  Future<String> addClass(String name, Map<String, int?> schedule) async {
    final col = await _classesCollection;
    final uID = userId;
    if (uID == null) throw Exception("User not authenticated");

    final safeSchedule = Map.fromEntries(schedule.entries.where((e) => e.value != null));

    return _firestore.runTransaction((transaction) async {
      final snapshot = await col.get();
      final newOrder = snapshot.size;

      final docRef = col.doc();
      transaction.set(docRef, {
        'name': name,
        'schedule': safeSchedule,
        'teacherID': uID,
        'order': newOrder,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    });
  }

  Future<void> updateClass(String classID, String name, Map<String, int?> schedule) async {
    final col = await _classesCollection;
    final safeSchedule = Map.fromEntries(schedule.entries.where((e) => e.value != null));

    await col.doc(classID).update({
      'name': name,
      'schedule': safeSchedule,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteClass(String classID) async {
    final col = await _classesCollection;
    await col.doc(classID).delete();
  }

  Future<void> reorderClasses(List<String> orderedIDs) async {
    final col = await _classesCollection;
    final batch = _firestore.batch();
    for (int i = 0; i < orderedIDs.length; i++) {
      final docRef = col.doc(orderedIDs[i]);
      batch.update(docRef, {'order': i});
    }
    await batch.commit();
  }

  Future<Map<String, dynamic>?> getClassById(String classID) async {
    final col = await _classesCollection;
    final doc = await col.doc(classID).get();
    if (!doc.exists) return null;
    return doc.data() as Map<String, dynamic>;
  }
}
