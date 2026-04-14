class MessageModel {
  final String id;
  final String sender;
  final String recipient;
  final String text;
  final String conversationId;
  final DateTime createdAt;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.sender,
    required this.recipient,
    required this.text,
    required this.conversationId,
    required this.createdAt,
    this.isRead = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      sender: json['sender'] ?? '',
      recipient: json['recipient'] ?? '',
      text: json['text'] ?? '',
      conversationId: json['conversationId'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'recipient': recipient,
      'text': text,
      'conversationId': conversationId,
    };
  }
}
