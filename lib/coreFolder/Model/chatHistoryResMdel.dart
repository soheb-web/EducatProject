class chatHistoryResModel {
  String? message;
  List<Chat>? chat;
  int? status;

  chatHistoryResModel({this.message, this.chat, this.status});

  chatHistoryResModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['chat'] != null) {
      chat = <Chat>[];
      json['chat'].forEach((v) {
        chat!.add(new Chat.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.chat != null) {
      data['chat'] = this.chat!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Chat {
  int? sender;
  String? message;
  String? timestamp;

  Chat({this.sender, this.message, this.timestamp});

  Chat.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    message = json['message'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp;
    return data;
  }
}