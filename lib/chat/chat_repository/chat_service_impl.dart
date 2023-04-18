import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/entities/conversation.dart';
import 'package:vooms/chat/entities/message.dart';

class ChatServiceImpl implements ChatService {
  final conversationsCollection =
      FirebaseFirestore.instance.collection('conversations');
  final AuthService _authService;

  ChatServiceImpl(this._authService);    

  @override
  Future<void> createConversation(
      String? name, String type, List<String> memberIds) async {
    List<Map<String, dynamic>> membersData = memberIds.map((userId) {
      return {
        'userId': userId,
        'lastSeen': Timestamp.now(),
      };
    }).toList();

    if (type == "user") {
      // One-to-one conversation
      membersData.sort((a, b) => a['userId'].compareTo(b['userId']));
      String id = membersData[0]['userId'] + "_" + membersData[1]['userId'];
      DocumentReference docRef = conversationsCollection.doc(id);

      Map<String, dynamic> data = {
        'type': type,
        'members': membersData,
      };

      if (name != null) {
        data['name'] = name;
      }

      await docRef.set(data);
    } else {
      // Group conversation
      await conversationsCollection.add({
        'name': name,
        'type': type,
        'members': membersData,
      });
    }
  }

  @override
  Future<void> sendMessage(
      String conversationId, String senderId, String content,
      {String? imageUrl, String? videoUrl}) async {
    CollectionReference messagesCollection =
        conversationsCollection.doc(conversationId).collection('messages');

    Map<String, dynamic> messageData = {
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.now(),
    };

    if (imageUrl != null) {
      String imageRefPath =
          'images/$conversationId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference imageRef = FirebaseStorage.instance.ref().child(imageRefPath);
      UploadTask uploadTask = imageRef.putString(
        imageUrl,
      );
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      messageData['imageUrl'] = downloadUrl;
    }

    if (videoUrl != null) {
      String videoRefPath =
          'videos/$conversationId/${DateTime.now().millisecondsSinceEpoch}.mp4';
      Reference videoRef = FirebaseStorage.instance.ref().child(videoRefPath);
      UploadTask uploadTask = videoRef.putString(videoUrl);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      messageData['videoUrl'] = downloadUrl;
    }

    messagesCollection.add(messageData);
  }

   @override
  Stream<List<Conversation>> getConversationsForUser(String userId) {
    return conversationsCollection
        .where('members', arrayContains: {'userId': userId})
        .snapshots()
        .map((querySnapshot) {
          List<Conversation> conversations = [];
          for (QueryDocumentSnapshot doc in querySnapshot.docs) {
            Conversation conversation = Conversation.fromFirestore(doc);
            conversation.id = doc.id;
            conversations.add(conversation);
          }
          return conversations;
        });
  }
  
  @override
  Stream<List<Message>> getMessagesForConversation(String conversationId) {
    return conversationsCollection
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      List<Message> messages = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Message message = Message.fromFirestore(data);
        message.id = doc.id;
        messages.add(message);
      }
      return messages;
    });
  }
   
 @override
Future<String> getConversationId(String user1Id, String user2Id) async {
  String conversationId;
  QuerySnapshot conversations = await conversationsCollection
      .where('members.userId', arrayContains: [user1Id, user2Id])
      .get();

  if (conversations.docs.isNotEmpty) {
    conversationId = conversations.docs.first.id;
  } else {
    List<String> memberIds = [user1Id, user2Id];
    memberIds.sort();
    conversationId = memberIds.join('_');
    await createConversation(null, 'user', memberIds);
  }

  return conversationId;
}



}
