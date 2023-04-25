import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  List<String> memberIds;
  String id;
  List<MemberDetail> memberDetail;
  String createdBy;
  String type;
  Timestamp createdAt;
  String name;
  RecentMessage? recentMessage;

  Conversation(
      {required this.memberIds,
      required this.id,
      required this.memberDetail,
      required this.createdBy,
      required this.type,
      required this.createdAt,
      required this.name,
      this.recentMessage});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    List<dynamic> memberDetailList = json['memberDetail'];
    List<MemberDetail> memberDetail =
        memberDetailList.map((e) => MemberDetail.fromJson(e)).toList();
    return Conversation(
        memberIds: (json['memberIds'] as List).map((e) => e as String).toList(),
        id: json['id'],
        memberDetail: memberDetail,
        createdBy: json['createdBy'],
        type: json['type'],
        createdAt: json['createdAt'],
        name: json['name'],
        recentMessage: json['recentMessage'] != null
            ? RecentMessage.fromJson(json['recentMessage'])
            : null);
  }
}

class MemberDetail {
  String userId;
  Timestamp lastSeen;
  String displayName;
  String? photoUrl;

  MemberDetail({
    required this.userId,
    required this.lastSeen,
    required this.displayName,
    this.photoUrl
  });

  factory MemberDetail.fromJson(Map<String, dynamic> json) {
    return MemberDetail(
      userId: json['userId'],
      lastSeen: json['lastSeen'],
      displayName: json['displayName'],
      photoUrl: json["photoUrl"]
    );
  }
}

class RecentMessage {
  final String message;
  final Timestamp sendAt;
  final String sentBy;

  RecentMessage(this.message, this.sendAt, this.sentBy);

  factory RecentMessage.fromJson(Map<String, dynamic> json) {
    return RecentMessage(json["message"], json["sentAt"], json["sentBy"]);
  }
}
