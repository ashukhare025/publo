part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}


final class UserSuccess extends UserState {
  final List<UserModel> users;
  UserSuccess({required this.users});
}

class UserFailure extends UserState {
  final String errorMessage;
  UserFailure(this.errorMessage);
}
class UserContactAdded extends UserState {}
class UserRequestAccepted extends UserState {}
class UserRequestRejected extends UserState {}