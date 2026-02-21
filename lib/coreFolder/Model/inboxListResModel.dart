import 'dart:convert';

InboxListResponse inboxListResponseFromJson(String str) =>
    InboxListResponse.fromJson(json.decode(str));

String inboxListResponseToJson(InboxListResponse data) =>
    json.encode(data.toJson());

class InboxListResponse {
  String? message;
  List<Inbox>? inbox;
  EgedUser? egedUser;
  int? status;

  InboxListResponse({
    this.message,
    this.inbox,
    this.egedUser,
    this.status,
  });

  factory InboxListResponse.fromJson(Map<String, dynamic> json) =>
      InboxListResponse(
        message: json["@message"],
        inbox: json["@inbox"] == null
            ? []
            : List<Inbox>.from(
                (json["@inbox"] as List).map((x) => Inbox.fromJson(x)),
              ),
        egedUser: json["@eged_user"] == null
            ? EgedUser()
            : EgedUser.fromJson(json["@eged_user"]),
        status: json["@status"],
      );

  Map<String, dynamic> toJson() => {
        "@message": message,
        "@inbox": inbox == null
            ? []
            : List<dynamic>.from(inbox!.map((x) => x.toJson())),
        "@eged_user": egedUser?.toJson(),
        "@status": status,
      };
}

class EgedUser {
  int? id;
  String? address;
  String? pincode;
  String? profileApproved;
  String? fcmToken;
  DateTime? updatedAt;
  String? city;
  String? fullName;
  String? phoneNumber;
  String? image;
  DateTime? lastActiveAt;
  DateTime? createdAt;

  EgedUser({
    this.id,
    this.address,
    this.pincode,
    this.profileApproved,
    this.fcmToken,
    this.updatedAt,
    this.city,
    this.fullName,
    this.phoneNumber,
    this.image,
    this.lastActiveAt,
    this.createdAt,
  });

  factory EgedUser.fromJson(Map<String, dynamic> json) => EgedUser(
        id: json["id"],
        address: json["address"]?.toString(),
        pincode: json["pincode"]?.toString(),
        profileApproved: json["profile_approved"]?.toString(),
        fcmToken: json["fcm_Token"]?.toString(),
        updatedAt: _safeDate(json["updated_at"]),
        city: json["city"]?.toString(),
        fullName: json["full_name"]?.toString(),
        phoneNumber: json["phone_number"]?.toString(),
        image: json["image"]?.toString(),
        lastActiveAt: _safeDate(json["last_active_at"]),
        createdAt: _safeDate(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "pincode": pincode,
        "profile_approved": profileApproved,
        "fcm_Token": fcmToken,
        "updated_at": updatedAt?.toIso8601String(),
        "city": city,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "image": image,
        "last_active_at": lastActiveAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
      };

  /// Safe date parsing helper
  static DateTime? _safeDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}

class Inbox {
  String? conversationId;
  OtherUser? otherUser;
  String? lastMessage;
  DateTime? timestamp;

  Inbox({
    this.conversationId,
    this.otherUser,
    this.lastMessage,
    this.timestamp,
  });

  factory Inbox.fromJson(Map<String, dynamic> json) => Inbox(
        conversationId: json["conversation_id"]?.toString(),
        otherUser: json["other_user"] == null
            ? OtherUser()
            : OtherUser.fromJson(json["other_user"]),
        lastMessage: json["last_message"]?.toString(),
        timestamp: EgedUser._safeDate(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "conversation_id": conversationId,
        "other_user": otherUser?.toJson(),
        "last_message": lastMessage,
        "timestamp": timestamp?.toIso8601String(),
      };
}

class OtherUser {
  int? id;
  String? name;
  String? profilePick;
  bool? isReaded;
  bool? senderYou;

  OtherUser({
    this.id,
    this.name,
    this.profilePick,
    this.isReaded,
    this.senderYou,
  });

  factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
        id: json["_id"],
        name: json["name"]?.toString(),
        profilePick: json["profilePick"]?.toString(),
        isReaded: json["is_readed"],
        senderYou: json["sender_you"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePick": profilePick,
        "is_readed": isReaded,
        "sender_you": senderYou,
      };
}
