import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Venues fetch
  Future<List<Map<String, dynamic>>> getVenues() async {
    final snapshot = await _db.collection('manu').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "title": data['title']?.toString() ?? "No Title",
        "address": data['address']?.toString() ?? "No Address",
        "lat": data['lat']?.toString() ?? "0",
        "lng": data['lng']?.toString() ?? "0",
        "image": data['image']?.toString() ?? "",
        "verification_code": data['verification_code']?.toString() ?? "-",
      };
    }).toList();
  }

  // Users fetch
  Future<List<Map<String, dynamic>>> getUsers() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "name": data['name']?.toString() ?? "No Name",
        "email": data['email']?.toString() ?? "No Email",
      };
    }).toList();
  }

  // Chats fetch
  Future<List<Map<String, dynamic>>> getChats() async {
    final snapshot = await _db.collection('chats').orderBy('timestamp').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        "id": doc.id,
        "sender": data['sender']?.toString() ?? "Unknown",
        "message": data['message']?.toString() ?? "",
        "timestamp": data['timestamp'] ?? 0,
      };
    }).toList();
  }
}
