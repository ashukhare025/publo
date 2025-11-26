import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'venue_state.dart';

class VenueCubit extends Cubit<VenueState> {
  VenueCubit() : super(VenueInitial());
}
