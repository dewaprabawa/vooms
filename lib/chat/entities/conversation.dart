import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String memberIds;
  String id;
  List<MemberDetail> memberDetail;
  String createdBy;
  String type;
  Timestamp createdAt;
  String name;

  Conversation({
    required this.memberIds,
    required this.id,
    required this.memberDetail,
    required this.createdBy,
    required this.type,
    required this.createdAt,
    required this.name,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    List<dynamic> memberDetailList = json['memberDetail'];
    List<MemberDetail> memberDetail = memberDetailList.map((e) => MemberDetail.fromJson(e)).toList();
    
    return Conversation(
      memberIds: json['memberIds'],
      id: json['id'],
      memberDetail: memberDetail,
      createdBy: json['createdBy'],
      type: json['type'],
      createdAt: json['createdAt'],
      name: json['name'],
    );
  }
}

class MemberDetail {
  String userId;
  Timestamp lastSeen;
  String displayName;

  MemberDetail({
    required this.userId,
    required this.lastSeen,
    required this.displayName,
  });

  factory MemberDetail.fromJson(Map<String, dynamic> json) {
    return MemberDetail(
      userId: json['userId'],
      lastSeen: json['lastSeen'],
      displayName: json['displayName'],
    );
  }
}
