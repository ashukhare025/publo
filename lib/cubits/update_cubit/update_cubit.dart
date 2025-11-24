import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit() : super(UpdateInitial());

  Future<void> registerUser({
    required String email,
    required String username,
    required String number,
  }) async {
    emit(UpdateLoading());
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(UpdateFailure(errMessage: "User not logged in"));
        return;
      }

      // Firestore me update
      await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
        {"username": username, "email": email, "number": number},
      );

      emit(UpdateSuccess());
    } catch (e) {
      emit(UpdateFailure(errMessage: e.toString()));
    }
  }
}
