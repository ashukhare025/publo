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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'user_state.dart';


class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch venue users — WITHOUT fetching self
  Future<void> fetchVenueUsers(String venueId) async {
    emit(UserLoading());

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final snap = await _firestore
          .collection('manu')
          .doc(venueId)
          .collection('users')
          .get();

      final users = snap.docs
          .map((d) => UserModel.fromJson(d.data()))
          .where((u) => u.uid != currentUser.uid) // ⚡ SKIP SELF
          .toList();

      emit(UserSuccess(users: users));
    } catch (e) {
      emit(UserFailure(e.toString()));
    }
  }

  Future<void> addToContacts(UserModel user) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final ref = _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("contacts")
          .doc(user.uid);

      final existing = await ref.get();
      if (existing.exists) {
        emit(UserFailure("Request already sent"));
        return;
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      await ref.set({
        "uid": user.uid,
        "name": user.name,
        "email": user.email,
        "image": user.image,
        "status": "pending",
        "addedAt": timestamp,
        "requestBy": currentUser.uid,
      });

      // also create the reverse doc for easier tracking
      final reverseRef = _firestore
          .collection("users")
          .doc(user.uid)
          .collection("contacts")
          .doc(currentUser.uid);

      await reverseRef.set({
        "uid": currentUser.uid,
        "name": currentUser.displayName ?? "",
        "email": currentUser.email ?? "",
        "image": currentUser.photoURL ?? "",
        "status": "pending",
        "addedAt": timestamp,
        "requestBy": currentUser.uid, // same sender
      });

      emit(UserContactAdded());
    } catch (e) {
      emit(UserFailure("Failed to add: $e"));
    }
  }


  Future<void> acceptContact(String otherUserId) async {
    emit(UserLoading());

    try {
      final current = FirebaseAuth.instance.currentUser;
      if (current == null) return;

      // Update my record
      await _firestore
          .collection("users")
          .doc(current.uid)
          .collection("contacts")
          .doc(otherUserId)
          .update({"status": "accepted"});

      // Update the other user's record
      await _firestore
          .collection("users")
          .doc(otherUserId)
          .collection("contacts")
          .doc(current.uid)
          .update({"status": "accepted"});

    } catch (e) {
      emit(UserFailure("Failed to accept contact: $e"));
    }
  }



  Future<void> rejectContact(String otherUserId) async {
    emit(UserLoading());

    try {
      final current = FirebaseAuth.instance.currentUser;
      if (current == null) return;

      // remove contact from both users
      await _firestore
          .collection("users")
          .doc(current.uid)
          .collection("contacts")
          .doc(otherUserId)
          .delete();

      await _firestore
          .collection("users")
          .doc(otherUserId)
          .collection("contacts")
          .doc(current.uid)
          .delete();

    } catch (e) {
      emit(UserFailure("Failed to reject contact: $e"));
    }
  }

  /// Fetch only accepted OR pending contacts
  Future<void> fetchContacts() async {
    emit(UserLoading());

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final snap = await _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("contacts")
          .orderBy("addedAt")
          .get();

      final users = snap.docs
          .map((d) => UserModel.fromJson(d.data()))
          .toList();

      emit(UserSuccess(users: users));
    } catch (e) {
      emit(UserFailure("Failed to load contacts: $e"));
    }
  }
}

class UserModel {
  final String uid;
  final String name;
  final String image;
  final String email;
  final String status; // "pending" | "accepted"
  final String requestBy; // NEW: uid of sender of the request

  UserModel({
    required this.uid,
    required this.name,
    required this.image,
    required this.email,
    required this.status,
    required this.requestBy,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      email: json["email"] ?? "",
      status: json["status"] ?? "pending",
      requestBy: json["requestBy"] ?? "", // NEW
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "image": image,
      "email": email,
      "status": status,
      "requestBy": requestBy, // NEW
    };
  }
}
