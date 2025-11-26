part of 'venue_cubit.dart';

@immutable
sealed class VenueState {}

final class VenueInitial extends VenueState {}

final class VenueLoading extends VenueState {}

final class VenueSuccess extends VenueState {}

final class VenueFailure extends VenueState {
  final String errMessage;
  VenueFailure({required this.errMessage});
}
