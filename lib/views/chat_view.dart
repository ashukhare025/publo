import 'package:firebase_auth/firebase_auth.dart';
import 'package:publo/constants.dart';
import 'package:publo/cubits/chat_cubit/chat_cubit.dart';
import 'package:publo/models/message_model.dart';
import 'package:publo/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  static String id = "ChatView";
  final String receiverId;
  final String receiverName;
  final String receiverImage;

  const ChatView({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  String? currentUserId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      setState(() {
        currentUserId = currentUser.uid;
      });

      // Attach listener for messages
      context.read<ChatCubit>().getMessages(
        currentUserId: currentUserId!,
        receiverId: widget.receiverId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(widget.receiverImage)),
            SizedBox(width: 10),
            Text(
              widget.receiverName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: "dubai",
              ),
            ),
          ],
        ),
      ),
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Image.asset(kLogoImage, height: 50),
      //       const SizedBox(width: 10),
      //       const Text(
      //         "Chat",
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontSize: 28,
      //           fontWeight: FontWeight.w500,
      //           fontFamily: "dubai",
      //         ),
      //       ),
      //     ],
      //   ),
      //   backgroundColor: kPrimaryColor,
      // ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                List<MessageModel> messagesList = [];
                if (state is ChatSuccess) {
                  messagesList = state.messagesList;
                }

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    final message = messagesList[index];

                    // Check if message is from current user
                    final isSender = message.senderId == currentUserId;

                    return Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSender
                              ? Colors.yellow.shade700
                              : kPrimaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(isSender ? 32 : 0),
                            bottomRight: Radius.circular(isSender ? 0 : 32),
                            topLeft: const Radius.circular(32),
                            topRight: const Radius.circular(32),
                          ),
                        ),
                        child: Text(
                          message.message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => sendMessageFunc(),
              decoration: InputDecoration(
                hintText: "Send Message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: kPrimaryColor),
                  onPressed: sendMessageFunc,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessageFunc() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendMessage(
      message: text,
      senderId: currentUserId!,
      receiverId: widget.receiverId,
    );

    controller.clear();

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
