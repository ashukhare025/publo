import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> registerUser({
    required String email,
    required String username,
    required String number,
  }) async {
    emit(HomeLoading());
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(HomeFailure(errMessage: "User not logged in"));
        return;
      }

      // Firestore me update
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
        {"username": username, "email": email, "number": number},
      );

      emit(HomeSuccess());
    } catch (e) {
      emit(HomeFailure(errMessage: e.toString()));
    }
  }
}
