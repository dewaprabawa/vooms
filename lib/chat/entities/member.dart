import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String userId;
  final Timestamp lastSeen;

  Member({required this.userId,required this.lastSeen});

  factory Member.fromFirestore(Map<String, dynamic> data) {
    return Member(
      userId: data['userId'],
      lastSeen: data['lastSeen'],
    );
  }
}
