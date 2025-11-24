part of 'update_cubit.dart';

@immutable
sealed class UpdateState {}

final class UpdateInitial extends UpdateState {}

final class UpdateLoading extends UpdateState {}

final class UpdateSuccess extends UpdateState {}

final class UpdateFailure extends UpdateState {
  final String errMessage;
  UpdateFailure({required this.errMessage});
}
