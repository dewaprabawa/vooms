abstract class ChatService {
  Future<void> createConversation(
      String name, String type, List<String> memberIds);
  Future<void> sendMessage(
      String conversationId, String senderId, String content,
      {String imageUrl, String videoUrl});
}
