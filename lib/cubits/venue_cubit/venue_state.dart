part of 'venue_cubit.dart';

@immutable
sealed class VenueState {}

final class VenueInitial extends VenueState {}

final class VenueLoading extends VenueState {}

final class VenueSuccess extends VenueState {
  final List<Map<String, dynamic>> venues;
  VenueSuccess({required this.venues});
}

final class VenueFailure extends VenueState {
  final String errMessage;
  VenueFailure({required this.errMessage});
}
