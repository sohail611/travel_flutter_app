import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  final String targetUserId;
  final String targetUserName;

  const ChatScreen({
    super.key,
    required this.targetUserId,
    required this.targetUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _currentUser = FirebaseAuth.instance.currentUser;

  String getChatId() {
    final ids = [_currentUser!.uid, widget.targetUserId]..sort();
    return ids.join('_');
  }

  Future<void> sendTextMessage(String text) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId())
        .collection('messages')
        .add({
      'text': text,
      'senderId': _currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final file = File(image.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    await ref.putFile(file);
    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId())
        .collection('messages')
        .add({
      'imageUrl': url,
      'senderId': _currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final mapUrl = 'https://www.google.com/maps?q=${position.latitude},${position.longitude}';

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId())
        .collection('messages')
        .add({
      'locationUrl': mapUrl,
      'senderId': _currentUser!.uid,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatId = getChatId();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.targetUserName),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data() as Map<String, dynamic>;
                    final isMe = msg['senderId'] == _currentUser!.uid;

                    Widget content;
                    if (msg['imageUrl'] != null) {
                      content = Image.network(msg['imageUrl'], width: 200);
                    } else if (msg['locationUrl'] != null) {
                      content = GestureDetector(
                        onTap: () => launchUrl(Uri.parse(msg['locationUrl'])),
                        child: Row(
                          children: const [
                            Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Location"),
                          ],
                        ),
                      );
                    } else {
                      content = Text(msg['text'] ?? '');
                    }

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.orange[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: content,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      sendTextMessage(_controller.text.trim());
                      _controller.clear();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.orange),
                  onPressed: sendImage,
                ),
                IconButton(
                  icon: const Icon(Icons.location_on, color: Colors.red),
                  onPressed: sendLocation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
