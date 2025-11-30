// //
// //
// // import 'package:publo/constants.dart';
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class MessageModel {
// //   final String message;
// //   final String senderId;
// //   final Timestamp createdAt;
// //
// //   MessageModel({
// //     required this.message,
// //     required this.senderId,
// //     required this.createdAt,
// //   });
// //
// //   factory MessageModel.fromJson(Map<String, dynamic> json) {
// //     return MessageModel(
// //       message: json[kMessageDocument],
// //       senderId: json[kSenderID],
// //       createdAt: json[kCreatedAtDocument] ?? Timestamp.now(),
// //     );
// //   }
// // }
//
//
// import 'package:publo/constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class MessageModel {
//   final String message;
//   final String senderId;
//   final Timestamp createdAt;
//
//   MessageModel({
//     required this.message,
//     required this.senderId,
//     required this.createdAt,
//   });
//
//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       message: (json[kMessageDocument] ?? "").toString(),
//       senderId: (json[kSenderID] ?? "").toString(),
//       createdAt: json[kCreatedAtDocument] is Timestamp
//           ? json[kCreatedAtDocument]
//           : Timestamp.now(),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants.dart';

class MessageModel {
  final String message;
  final String senderId;
  final String receiverId;
  final Timestamp? createdAt;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: (json[kMessageDocument] ?? "").toString(),
      senderId: (json[kSenderID] ?? "").toString(),
      receiverId: (json['receiverId'] ?? "").toString(),
      createdAt: json[kCreatedAtDocument] is Timestamp
          ? json[kCreatedAtDocument]
          : Timestamp.now(),
    );
  }
}
