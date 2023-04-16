import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vooms/chat/entities/member.dart';
import 'package:vooms/chat/entities/message.dart';

class Conversation {
   String id;
   String name;
   String type;
   List<Member> members;
   List<Message> messages;

  Conversation({required this.id,required this.name,required this.type,required this.members,required this.messages});

  factory Conversation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<Member> members = List<Member>.from(data['members'].map((m) {
      return Member.fromFirestore(m);
    }));

    List<Message> messages = List<Message>.from(data['messages'].map((m) {
      return Message.fromFirestore(m);
    }));

    return Conversation(
      id: doc.id,
      name: data['name'],
      type: data['type'],
      members: members,
      messages: messages,
    );
  }
}