import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:publo/models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final CollectionReference messagesCollection =
  FirebaseFirestore.instance.collection("messages");

  List<MessageModel> messagesList = [];

  /// Generate unique chatId for two users
  String getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return "${sorted[0]}_${sorted[1]}";
  }

  /// Send message only if contact is accepted
  Future<void> sendMessage({
    required String message,
    required String senderId,
    required String receiverId,
  }) async {
    if (message.trim().isEmpty) return;

    final chatId = getChatId(senderId, receiverId);

    try {
      await messagesCollection
          .doc(chatId)
          .collection("chats")
          .add({
        "message": message.trim(),
        "senderId": senderId,     // Must be current user uid
        "receiverId": receiverId, // Must be recipient uid
        "timestamp": FieldValue.serverTimestamp(),
      });

    } catch (e) {
      emit(ChatFailure(error: e.toString()));
    }
  }
  void getMessages({
    required String currentUserId,
    required String receiverId,
  }) {
    final chatId = getChatId(currentUserId, receiverId);

    messagesCollection
        .doc(chatId)
        .collection("chats")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {
      messagesList = snapshot.docs
          .map((doc) =>
          MessageModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      emit(ChatSuccess(messagesList: messagesList));
    });
  }

}
