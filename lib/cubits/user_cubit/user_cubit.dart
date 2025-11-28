// // import 'package:bloc/bloc.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/src/widgets/icon_data.dart';
// // import 'package:meta/meta.dart';
// //
// // part 'user_state.dart';
// //
// // class UserCubit extends Cubit<UserState> {
// //   UserCubit() : super(UserInitial());
// //
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //
// //   /// Fetch all users from Firestore
// //   Future<void> fetchUsers() async {
// //     emit(UserLoading());
// //     try {
// //       final snapshot = await _firestore.collection("manu").get();
// //
// //       if (snapshot.docs.isEmpty) {
// //         emit(UserFailure("No users found"));
// //         return;
// //       }
// //
// //       // Map each document to UserModel
// //       final users = snapshot.docs.map((doc) {
// //         final data = doc.data();
// //         return UserModel(
// //           image: data['image']?.toString() ?? "",
// //           name: data['name']?.toString() ?? "",
// //           IconData: data['chat'].toString() ?? "",
// //           IconData: data['person'].toString() ?? "",
// //         );
// //       }).toList();
// //
// //       emit(UserSuccess(users: users));
// //     } catch (e) {
// //       emit(UserFailure("Failed to load users: $e"));
// //     }
// //   }
// // }
// //
// // class UserModel {
// //   final String image;
// //   final String name;
// //   final IconData chat;
// //   final IconData person;
// //
// //   UserModel(
// //     this.chat,
// //     this.person, {
// //     required this.image,
// //     required this.name,
// //     required String person,
// //     required IconData,
// //   });
// //
// //   Map<String, String> toMap() {
// //     return {'image': image, 'name': name};
// //   }
// // }
//
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';
//
// part 'user_state.dart';
//
// class UserCubit extends Cubit<UserState> {
//   UserCubit() : super(UserInitial());
//
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   /// Fetch all users from Firestore
//   Future<void> fetchUsers() async {
//     emit(UserLoading());
//     try {
//       final snapshot = await _firestore.collection("users").get();
//
//       if (snapshot.docs.isEmpty) {
//         emit(UserFailure("No users found"));
//         return;
//       }
//
//       // Map each document to UserModel
//       final users = snapshot.docs.map((doc) {
//         final data = doc.data();
//         return UserModel(
//           image: data['image']?.toString() ?? "",
//           name: data['name']?.toString() ?? "",
//         );
//       }).toList();
//
//       emit(UserSuccess(users: users));
//     } catch (e) {
//       emit(UserFailure("Failed to load users: $e"));
//     }
//   }
// }
//
// class UserModel {
//   final String image;
//   final String name;
//
//   UserModel({required this.image, required this.name});
//
//   Map<String, String> toMap() {
//     return {'image': image, 'name': name};
//   }
// }

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all users from Firestore
  Future<void> fetchUsers() async {
    emit(UserLoading());
    try {
      final snapshot = await _firestore.collection("users").get();

      if (snapshot.docs.isEmpty) {
        emit(UserFailure("No users found"));
        return;
      }

      // Map each document to UserModel
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel(
          image: data['image']?.toString() ?? "",
          name: data['name']?.toString() ?? "",
          chatIcon: Icons.chat, // Replace with proper logic if dynamic
          personIcon: Icons.person, // Replace with proper logic if dynamic
        );
      }).toList();

      emit(UserSuccess(users: users));
    } catch (e) {
      emit(UserFailure("Failed to load users: $e"));
    }
  }
}

class UserModel {
  final String image;
  final String name;
  final IconData chatIcon;
  final IconData personIcon;

  UserModel({
    required this.image,
    required this.name,
    required this.chatIcon,
    required this.personIcon,
  });

  Map<String, String> toMap() {
    return {'image': image, 'name': name};
  }
}
