import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'detail_notification_page.dart'; // Import trang Chi tiết thông báo

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late FirebaseMessaging _messaging;
  List<NotificationMessage> _newMessages = [];
  List<NotificationMessage> _oldMessages = [];

  @override
  void initState() {
    super.initState();
    _messaging = FirebaseMessaging.instance;

    initPushNotification();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _oldMessages.insertAll(0, _newMessages);
        _newMessages = [NotificationMessage(message: message, isRead: false)];
      });
      print("Message data: ${message.data}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });
  }

  Future<void> initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  }

  void handleMessage(RemoteMessage? message) {
    if (message != null) {
      setState(() {
        _oldMessages.insertAll(0, _newMessages);
        _newMessages = [NotificationMessage(message: message, isRead: true)];
      });
      _navigateToDetailPage(NotificationMessage(message: message, isRead: true));
    }
  }

  void _markAsRead(int index, bool isNewMessage) {
    setState(() {
      if (isNewMessage) {
        _newMessages[index].isRead = true;
      } else {
        _oldMessages[index].isRead = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _newMessages = _newMessages.map((message) {
        message.isRead = true;
        return message;
      }).toList();

      _oldMessages = _oldMessages.map((message) {
        message.isRead = true;
        return message;
      }).toList();
    });
  }

  void _navigateToDetailPage(NotificationMessage notificationMessage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailNotificationPage(
          title: notificationMessage.message.notification?.title ?? 'No Title',
          body: notificationMessage.message.notification?.body ?? 'No Body',
          imgUrl: notificationMessage.message.data['imgUrl'] ?? '',
        ),
      ),
    ).then((_) {
      // Mark notification as read when returning to notification page
      setState(() {
        int newIndex = _newMessages.indexOf(notificationMessage);
        if (newIndex != -1) {
          _newMessages[newIndex].isRead = true;
        } else {
          int oldIndex = _oldMessages.indexOf(notificationMessage);
          if (oldIndex != -1) {
            _oldMessages[oldIndex].isRead = true;
          }
        }
      });
    });
  }

  String _truncateBody(String body, int wordLimit) {
    List<String> words = body.split(' ');
    if (words.length > wordLimit) {
      return words.sublist(0, wordLimit).join(' ') + '...';
    } else {
      return body;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'markAllAsRead') {
                _markAllAsRead();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'markAllAsRead',
                  child: Text('Đánh dấu tất cả đã đọc'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView.builder(
          itemCount: _newMessages.isNotEmpty
              ? _newMessages.length + (_oldMessages.isNotEmpty ? 1 : 0) + _oldMessages.length + 1
              : _oldMessages.length,
          itemBuilder: (context, index) {
            if (_newMessages.isEmpty && _oldMessages.isEmpty) {
              return Center(child: Text('Không có thông báo'));
            }
            if (index == 0 && _newMessages.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Bây giờ',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else if (index < _newMessages.length + 1) {
              final message = _newMessages[index - 1];
              return GestureDetector(
                onTap: () {
                  _markAsRead(index - 1, true);
                  _navigateToDetailPage(message); // Chuyển hướng khi nhấp vào container
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: message.isRead
                        ? Colors.white
                        : Color.fromARGB(255, 197, 246, 199),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active,
                          size: 40.0, color: Colors.blue),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.message.notification?.title ?? 'No Title',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: message.isRead ? Colors.black : Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              _truncateBody(
                                  message.message.notification?.body ?? 'No Body',
                                  10),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: message.isRead ? Colors.black : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (index == _newMessages.length + 1 && _oldMessages.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Trước đó',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              final oldIndex = index - _newMessages.length - 2;
              final message = _oldMessages[oldIndex];
              return GestureDetector(
                onTap: () {
                  _markAsRead(oldIndex, false);
                  _navigateToDetailPage(message); // Chuyển hướng khi nhấp vào container
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: message.isRead
                        ? Colors.white
                        : Color.fromARGB(255, 197, 246, 199),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active,
                          size: 40.0, color: Colors.blue),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.message.notification?.title ?? 'No Title',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: message.isRead ? Colors.black : Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              _truncateBody(
                                  message.message.notification?.body ?? 'No Body',
                                  10),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: message.isRead ? Colors.black : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class NotificationMessage {
  final RemoteMessage message;
  bool isRead;

  NotificationMessage({required this.message, this.isRead = false});
}
