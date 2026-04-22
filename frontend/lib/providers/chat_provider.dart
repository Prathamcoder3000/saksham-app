import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';
import 'dart:convert';

class ChatProvider with ChangeNotifier {
  late io.Socket socket;
  List<MessageModel> _messages = [];
  bool _isConnected = false;

  List<MessageModel> get messages => _messages;
  bool get isConnected => _isConnected;

  void initSocket(String userId) {
    socket = io.io(ApiService.socketUrl, io.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());

    socket.connect();

    socket.onError((data) {
      print('Socket Error: $data');
      _isConnected = false;
      notifyListeners();
    });

    socket.onConnect((_) {
      _isConnected = true;
      socket.emit('join', {'userId': userId});
      notifyListeners();
    });

    socket.on('message', (data) {
      final newMessage = MessageModel.fromJson(data);
      _messages.add(newMessage);
      notifyListeners();
    });

    socket.onDisconnect((_) {
      _isConnected = false;
      notifyListeners();
    });
  }

  Future<void> fetchMessages(String conversationId, String token) async {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}/messages/$conversationId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List ListData = data['data'];
      _messages = ListData.map((m) => MessageModel.fromJson(m)).toList();
      notifyListeners();
    }
  }

  Future<void> sendMessage(String recipient, String text, String conversationId, String token) async {
    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'recipient': recipient,
        'text': text,
        'conversationId': conversationId,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final sentMessage = MessageModel.fromJson(data['data']);
      _messages.add(sentMessage);
      notifyListeners();
    }
  }

  void addMessage(MessageModel message) {
    _messages.add(message);
    notifyListeners();
  }

  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }
}
