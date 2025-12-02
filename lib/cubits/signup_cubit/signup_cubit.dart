import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  Future<void> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(SignupLoading());

    try {
      UserCredential useCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseAuth.instance.signOut();

      emit(SignupSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignupFailure(errMessage: "weak password"));
      } else if (e.code == 'email-already-in-use') {
        emit(SignupFailure(errMessage: "email already in use"));
      }
    } on Exception catch (e) {
      emit(SignupFailure(errMessage: e.toString()));
    }
  }
}
