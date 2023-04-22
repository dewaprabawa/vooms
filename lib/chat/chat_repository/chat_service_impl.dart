import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vooms/authentication/repository/auth_service.dart';
import 'package:vooms/authentication/repository/user_model.dart';
import 'package:vooms/chat/chat_repository/chat_service.dart';
import 'package:vooms/chat/entities/member.dart';
import 'package:vooms/chat/entities/message.dart';
import 'package:vooms/shareds/general_helper/firebase_key_constant.dart';

class ChatServiceImpl implements ChatService {
  late final CollectionReference _groupReference;
  late final CollectionReference _collectionUserReference;
  late final CollectionReference _messageReference;
  final AuthService _authService;

  ChatServiceImpl(this._authService) {
    _groupReference = FirebaseFirestore.instance
        .collection(FirebaseKeyConstant.collectionGroupKey);
    _messageReference = FirebaseFirestore.instance
        .collection(FirebaseKeyConstant.collectionMessageKey);
    _collectionUserReference = FirebaseFirestore.instance
        .collection(FirebaseKeyConstant.collectionUserKey);
  }
  @override
  Future<void> createMember(String? name, String type, List<String> memberIds,
      String senderId) async {
    try {
      // Get details of all members
      final membersDetails = await _createMemberDetail(memberIds);

      // Create a unique id for the group based on sorted member ids
      final memberId = _createMemberId(memberIds);

      // Check if a group with the same member ids already exists
      final participants =
          await _groupReference.where('memberIds', isEqualTo: memberId).get();

      // If a group with the same member ids exists, return without creating a new one
      if (participants.docs.isNotEmpty) {
        return;
      }

      // Create a new group
      Map<String, dynamic> data = {
        'createdAt': Timestamp.now(),
        'id': memberId,
        'createdBy': senderId,
        'type': type,
        'memberIds': memberId,
        'memberDetail': membersDetails,
        if (name != null) 'name': name,
      };
      await _groupReference.doc(memberId).set(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendMessage(
      List<String> memberIds, String senderId, String content,
      {String? imageUrl, String? videoUrl}) async {
    final memberId = _createMemberId(memberIds);

    Map<String, dynamic> messageData = {
      'senderId': senderId,
      'content': content,
      'timestamp': Timestamp.now(),
    };

    if (imageUrl != null) {
      String imageRefPath =
          'images/$memberId/${DateTime.now().millisecondsSinceEpoch}.jpg';
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
          'videos/$memberId/${DateTime.now().millisecondsSinceEpoch}.mp4';
      Reference videoRef = FirebaseStorage.instance.ref().child(videoRefPath);
      UploadTask uploadTask = videoRef.putString(videoUrl);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      messageData['videoUrl'] = downloadUrl;
    }

    await _messageReference
        .doc(memberId)
        .collection("messages")
        .add(messageData);

    await _updateMemberRecentMessage(memberId, content, senderId);
  }

  @override
  Stream<List<Member>> getMemeberByUserId(String userId) {
    return _groupReference
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
      List<Member> conversations = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Member member = Member.fromJson(doc.data()!.toMap());
        conversations.add(member);
      }
      return conversations;
    });
  }

  @override
  Stream<List<Message>> getMessagesByMemberIds(List<String> ids) {
    return _messageReference
        .doc(_createMemberId(ids))
        .collection('messages')
        .orderBy('timestamp', descending: false)
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
  Future<UserModel?> currentUser() async {
    final model = await _authService.currentUser;
    if (model != null) {
      return model;
    }
    return null;
  }

  Future<Map<String, dynamic>> _getUserPhotoUrl(String userId) async {
    DocumentSnapshot<Object?> snapshot =
        await _collectionUserReference.doc(userId).get();

    if (snapshot.exists) {
      return (snapshot.data() as Map<String, dynamic>);
    } else {
      return {};
    }
  }

  Future<void> _updateMemberRecentMessage(
      String groupId, String content, String senderId) async {
    await _groupReference.doc(groupId).update({
      "recentMessage": {
        "message": content,
        "sentAt": Timestamp.now(),
        "sentBy": senderId
      }
    });
  }

  Future<List<Map<String, dynamic>>> _createMemberDetail(
      List<String> memberIds) async {
    List<Map<String, dynamic>> membersDetails = [];

    for (String memberId in memberIds) {
      Map<String, dynamic> userData = await _getUserPhotoUrl(memberId);

      String fullName =
          userData.containsKey('fullname') ? userData['fullname'] : '';

      Map<String, dynamic> memberDetail = {
        'lastSeen': Timestamp.now(),
        'displayName': fullName,
        'userId': memberId,
      };

      membersDetails.add(memberDetail);
    }

    return membersDetails;
  }

  String _createMemberId(List<String> memberIds) {
    String memberId = "";
    memberIds.sort((a, b) => a.compareTo(b));
    for (int i = 0; i < memberIds.length; i++) {
      if (i == memberIds.length - 1) {
        memberId += memberIds[i];
      } else {
        memberId += memberIds[i] + "_";
      }
    }
    return memberId;
  }
  
  @override
  Stream<Member> getMemberById(List<String> ids) {
    print(ids);
    return _groupReference.doc(_createMemberId(ids)).snapshots().map((event){
     print(event.data());
      return Member.fromJson(event.data()!.toMap());
    });
  }
}

extension on Object {
  Map<String, dynamic> toMap() {
    return this as Map<String, dynamic>;
  }
}

extension TimeStampExtension on Timestamp {
  String toTime() {
    // Convert the Timestamp to a DateTime object
    final dateTime = this.toDate();

    // Calculate the difference in time
    final diff = DateTime.now().difference(dateTime);

    // Convert the difference to a human-readable format
    if (diff.inDays > 2) {
      return '${diff.inDays} days ago';
    } else if (diff.inDays == 2) {
      return '2 days ago';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}




