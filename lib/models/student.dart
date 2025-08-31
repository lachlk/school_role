import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final String email;
  final int yearLevel;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.yearLevel,
  });

  factory Student.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      yearLevel: data['yearLevel'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'yearLevel': yearLevel,
    };
  }

  @override
  String toString() => name;
}
