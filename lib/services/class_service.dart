import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'classes';

  String get currentUserId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }
    return user.uid;
  }

  Stream<List<Map<String, dynamic>>> streamClassList() {
    final uID = currentUserId;
    return _firestore
        .collection(collectionName)
        .where('userID', arrayContains: uID)
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'name': data['name'] ?? 'Unnamed',
          'schedule': data['schedule'] ?? {},
          'order': data['order'] ?? 0,
          'createdAt': data['createdAt'],
        };
      }).toList();
    });
  }

  Future<void> addClass(String name, Map<String, int?> schedule) async {
    final uID = currentUserId;
    final safeSchedule = Map.fromEntries(
      schedule.entries.where((e) => e.value != null),
    );

    try {
      final snapshot = await _firestore
          .collection(collectionName)
          .where('userID', arrayContains: uID)
          .get();
      final newOrder = snapshot.size;

      await _firestore.collection(collectionName).add({
        'name': name,
        'schedule': safeSchedule,
        'userID': [uID],
        'order': newOrder,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add class: $e');
    }
  }

  Future<void> updateClass(
      String classID, String name, Map<String, int?> schedule) async {
    final safeSchedule = Map.fromEntries(
      schedule.entries.where((e) => e.value != null),
    );

    await _firestore.collection(collectionName).doc(classID).update({
      'name': name,
      'schedule': safeSchedule,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteClass(String classID) async {
    await _firestore.collection(collectionName).doc(classID).delete();
  }

  Future<void> reorderClasses(List<String> orderedIDs) async {
    final batch = _firestore.batch();
    for (int i = 0; i < orderedIDs.length; i++) {
      final docRef = _firestore.collection(collectionName).doc(orderedIDs[i]);
      batch.update(docRef, {'order': i});
    }
    await batch.commit();
  }

  Future<Map<String, dynamic>?> getClassById(String classID) async {
    final doc = await _firestore.collection(collectionName).doc(classID).get();
    if (!doc.exists) return null;
    return doc.data();
  }
}