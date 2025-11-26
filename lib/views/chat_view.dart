import 'package:publo/constants.dart';
import 'package:publo/cubits/chat_cubit/chat_cubit.dart';
import 'package:publo/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});
  static String id = "ChatView";

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(kLogoImage, height: 50),
            const SizedBox(width: 10),
            Text(
              "Chat",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w500,
                fontFamily: "dubai",
              ),
            ),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var messagesList = BlocProvider.of<ChatCubit>(
                  context,
                ).messagesList;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    return messagesList[index].senderId == email
                        ? ChatBubble(message: messagesList[index])
                        : ChatBubbleForFriend(message: messagesList[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18),
            child: Padding(
              padding: EdgeInsets.all(18),
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (data) {
                  sendMessageFunc(email);
                },
                decoration: InputDecoration(
                  hintText: "Send Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: kPrimaryColor),
                    onPressed: () {
                      sendMessageFunc(email);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendMessageFunc(String email) {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    BlocProvider.of<ChatCubit>(
      context,
    ).sendMessage(message: text, email: email);

    controller.clear();

    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
