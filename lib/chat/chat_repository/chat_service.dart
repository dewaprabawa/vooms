import 'package:vooms/chat/entities/conversation.dart';
import 'package:vooms/chat/entities/message.dart';

abstract class ChatService {
  Future<void> createConversation(
      String name, String type, List<String> memberIds);
  Future<void> sendMessage(
      String conversationId, String senderId, String content,
      {String imageUrl, String videoUrl});
  Stream<List<Message>> getMessagesForConversation(String conversationId);
  Stream<List<Conversation>> getConversationsForUser(String userId);
  Future<String> getConversationId(String user1Id, String user2Id);
}
