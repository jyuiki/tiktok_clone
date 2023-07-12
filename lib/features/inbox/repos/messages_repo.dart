import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message_medel.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessages(MessageModel message) async {
    await _db
        .collection("chat_rooms")
        .doc("o4zISOfdLHfAGctokMkX")
        .collection("texts")
        .add(message.toJson());
  }
}

final messagesRepo = Provider((ref) => MessagesRepo());
