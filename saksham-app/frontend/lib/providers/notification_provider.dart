import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class NotificationProvider with ChangeNotifier {
  int _unreadCount = 0;
  List<AppNotification> _notifications = [];

  int get unreadCount => _unreadCount;
  List<AppNotification> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    try {
      final response = await ApiService.get('/notifications');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'] as List;
        _notifications = data.map((json) => AppNotification.fromJson(json)).toList();
        _unreadCount = _notifications.where((n) => !n.isRead).length;
        notifyListeners();
      }
    } catch (e) {
      // Handle error gracefully
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final response = await ApiService.patch('/notifications/read-all', {});
      if (response.statusCode == 200) {
        _unreadCount = 0;
        for (var n in _notifications) {
          n.isRead = true;
        }
        notifyListeners();
      }
    } catch (e) {
      // Handle error gracefully
    }
  }
}


class AppNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isEmergency;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title, 
    required this.message, 
    required this.time, 
    this.isEmergency = false,
    this.isRead = false,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    String formattedTime = "just now";
    if (json['createdAt'] != null) {
      final date = DateTime.parse(json['createdAt']);
      formattedTime = DateFormat('hh:mm a').format(date);
    }
    return AppNotification(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Notification',
      message: json['message'] ?? '',
      time: formattedTime,
      isEmergency: json['type'] == 'emergency',
      isRead: json['isRead'] ?? false,
    );
  }
}
