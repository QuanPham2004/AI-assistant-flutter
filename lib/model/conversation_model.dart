class ConversationMessage {
  final String userID;
  final String message;
  final DateTime timestamp;

  ConversationMessage({
    required this.userID,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
