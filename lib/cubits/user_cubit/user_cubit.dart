import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void fetchUser() {
    emit(UserLoading());

    try {
      final json = {
        "name": "David David",
        // "image": "assets/images/person1.jpg", // optional
      };

      final user = UserModel.fromMap(json);

      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError("Failed to load user"));
    }
  }
}

class UserModel {
  final String? image;
  final String? name;

  UserModel({this.image, this.name});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(image: map["image"], name: map["name"]);
  }
}
