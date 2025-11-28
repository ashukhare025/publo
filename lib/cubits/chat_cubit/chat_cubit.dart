import 'package:bloc/bloc.dart';
import 'package:publo/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../constants.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );
  List<MessageModel> messagesList = [];
  void sendMessage({required String message, required String email}) async {
    try {
      print("➡ Trying to write to Firestore...");
      await messages.add({
        kMessageDocument: message,
        kCreatedAtDocument: FieldValue.serverTimestamp(),
        kSenderID: email,
      });
      print("✅ Write success!");
    } catch (e) {
      print("❌ Firestore Write Error: $e");
    }
  }

  void getMessages() {
    messages.orderBy(kCreatedAtDocument, descending: true).snapshots().listen((
      event,
    ) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(
          MessageModel.fromJson(doc.data() as Map<String, dynamic>),
        );
      }
      emit(ChatSuccess(messagesList: messagesList));
    });
  }
}

// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
//
// import '../user_cubit/user_cubit.dart';
// part 'user_state.dart';
// class UserCubit extends Cubit<UserState> {
//   UserCubit() : super(UserInitial());
//   void fetchUser() {
//     emit(UserLoading());
//
//     try { final json = { "name": "David David",
//     "image": "assets/images/person1.jpg",optional
//     };
//       final user = UserModel.fromMap(json);
//       emit(UserLoaded(user));
//     } catch (e) { emit(UserError("Failed to load user"));
//     }
//   }
// }
//
// class UserModel {
//   final String? image;
//   final String? name;
//
//   UserModel({this.image, this.name});
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(image: map["image"], name: map["name"]);
//   }
// }
