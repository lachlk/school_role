import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseDatabaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  String? get userId => auth.currentUser?.uid;

  Future<String> get schoolId async {
    final uid = userId;
    if (uid == null) throw Exception("User not authenticated");
    return uid;
  }

  Future<DocumentReference> schoolDoc() async {
    final id = await schoolId;
    return db.collection('schools').doc(id);
  }

  Future<List<QueryDocumentSnapshot>> getDocuments(
    String collectionPath, {
    Query Function(Query)? queryBuilder,
  }) async {
    Query query = db.collection(collectionPath);
    if (queryBuilder != null) query = queryBuilder(query);
    final result = await query.get();
    return result.docs;
  }

  Future<DocumentReference> addDocument(
      String collectionPath, Map<String, dynamic> data) {
    return db.collection(collectionPath).add(data);
  }

  Future<void> updateDocument(
      String collectionPath, String docId, Map<String, dynamic> data) {
    return db.collection(collectionPath).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collectionPath, String docId) {
    return db.collection(collectionPath).doc(docId).delete();
  }
}
