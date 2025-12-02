part of 'chat_cubit.dart';


@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<MessageModel> messagesList;
  ChatSuccess({required this.messagesList});
}

class ChatFailure extends ChatState {
  final String error;
  ChatFailure({required this.error});
}
