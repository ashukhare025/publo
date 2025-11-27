// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:meta/meta.dart';
//
// part 'user_state.dart';
//
// class UserCubit extends Cubit<UserState> {
//   UserCubit() : super(UserInitial());
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> fetchUser() async {
//     emit(UserLoading());
//
//     try {
//       // 🔥 Firestore se document fetch
//       DocumentSnapshot snapshot = await _firestore
//           .collection("users")
//           .doc("user1")
//           .get();
//
//       if (!snapshot.exists) {
//         emit(UserError("User not found"));
//         return;
//       }
//
//       final user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
//       emit(UserLoaded(user));
//     } catch (e) {
//       emit(UserError("Failed to load user: $e"));
//     }
//   }
// }
//
// class UserModel {
//   final String? image;
//   final String? name;
//
//   UserModel({this.image, this.name});
//
//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(image: map["image"], name: map["name"]);
//   }
// }

// lib/cubits/user_cubit/user_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchUser() async {
    emit(UserLoading());
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(UserError("User not logged in"));
        return;
      }

      final snapshot = await _firestore.collection("users").doc(uid).get();
      if (!snapshot.exists) {
        emit(UserError("User not found"));
        return;
      }

      final user = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError("Failed to load user: $e"));
    }
  }
}

class UserModel {
  final String? image;
  final String? name;
  final String? email;
  UserModel({this.image, this.name, this.email});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      image: map['image'] as String?,
      name: map['name'] as String? ?? map['username'] as String?,
      email: map['email'] as String?,
    );
  }
}
