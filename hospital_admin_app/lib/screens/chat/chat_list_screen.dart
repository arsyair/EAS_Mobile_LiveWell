import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin - Chat List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF001F54), // Navy Blue seperti dashboard
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return Center(
              child: Text(
                'No chats available',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              Map<String, dynamic>? chatData = chat.data() as Map<String, dynamic>?;

              String lastMessage = chatData?['lastMessage'] ?? 'No messages yet';
              var timestampRaw = chatData?['timestamp'];

              // Konversi timestamp jika tipe data adalah Timestamp
              DateTime? time;
              if (timestampRaw is Timestamp) {
                time = timestampRaw.toDate();
              } else if (timestampRaw is String) {
                time = DateTime.tryParse(timestampRaw);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF001F54),
                      child: Icon(Icons.chat, color: Colors.white),
                    ),
                    title: Text(
                      'Chat ID: ${chat.id}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      lastMessage,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: time != null
                        ? Text(
                            '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatId: chat.id),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
