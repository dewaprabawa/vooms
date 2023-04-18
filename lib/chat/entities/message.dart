import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  final String senderId;
  final String content;
  final Timestamp timestamp;

  Message(
      {required this.id,
      required this.senderId,
      required this.content,
      required this.timestamp});

  factory Message.fromFirestore(Map<String, dynamic> data) {
    return Message(
      id: data['id'] ?? "",
      senderId: data['senderId'],
      content: data['content'],
      timestamp: data['timestamp'],
    );
  }
}