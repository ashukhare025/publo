import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'venue_state.dart';

class VenueCubit extends Cubit<VenueState> {
  VenueCubit() : super(VenueInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchVenues() async {
    emit(VenueLoading());
    try {
      // Fetch snapshot from Firebase
      final snapshot = await _firestore.collection('manu').get();

      // Null-safe mapping
      final venues = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "title": data['title'],
          "address": data['address'],
          "lat": data['lat'],
          "lng": data['lng'],
          "image": data['image'],
          "verification_code": data['verification_code'],
        };
      }).toList();

      emit(VenueSuccess(venues: venues));
    } catch (e) {
      emit(VenueFailure(errMessage: e.toString()));
    }
  }
}
