import 'package:vooms/authentication/repository/user_model.dart';
import 'package:vooms/chat/entities/member.dart';
import 'package:vooms/chat/entities/message.dart';

abstract class ChatService {
  Future<void> createMember(
      String name, String type, List<String> memberIds, String senderId);
  Future<void> sendMessage(
      List<String> memberIds, String senderId, String content,
      {String imageUrl, String videoUrl});
  Stream<List<Message>> getMessagesByMemberIds(List<String> ids);
  Stream<Member> getMemberById(List<String> ids);
  Stream<List<Member>> getMemeberByUserId(String userId);
  Future<UserModel?> currentUser();
}


