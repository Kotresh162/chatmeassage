import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final String selectedUserId;
  final String selectedUserName;

  const ChatScreen({super.key, required this.selectedUserId, required this.selectedUserName});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();

  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser?.uid;
  }

  String getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode ? "$userId1\_$userId2" : "$userId2\_$userId1";
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String chatId = getChatId(currentUserId!, widget.selectedUserId);

      try {
        await _firestore.collection('messages').doc(chatId).set({
          'users': [currentUserId, widget.selectedUserId],
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await _firestore.collection('messages').doc(chatId).collection('chats').add({
          'message': _messageController.text,
          'senderId': currentUserId,
          'receiverId': widget.selectedUserId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        _messageController.clear();
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    }
  }

  void deleteMessage(String chatId, String messageId) async {
    try {
      await _firestore.collection('messages').doc(chatId).collection('chats').doc(messageId).delete();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String chatId = getChatId(currentUserId!, widget.selectedUserId);

    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.selectedUserName}")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore
                  .collection('messages')
                  .doc(chatId)
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((message) {
                    bool isSender = message['senderId'] == currentUserId;
                    return ListTile(
                      title: Align(
                        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSender ? Colors.blue[300] : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(message['message']),
                        ),
                      ),
                      subtitle: Text(isSender ? "You" : "Them"),
                      trailing: isSender
                          ? IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteMessage(chatId, message.id),
                            )
                          : null,
                    );
                  }).toList(),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: "Type a message"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
