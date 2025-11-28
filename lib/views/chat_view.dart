// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:publo/constants.dart';
// import 'package:publo/cubits/chat_cubit/chat_cubit.dart';
// import 'package:publo/widgets/chat_bubble.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class ChatView extends StatefulWidget {
//   const ChatView({super.key});
//   static String id = "ChatView";
//
//   @override
//   State<ChatView> createState() => _ChatViewState();
// }
//
// class _ChatViewState extends State<ChatView> {
//   final ScrollController _scrollController = ScrollController();
//
//   TextEditingController controller = TextEditingController();
//
//   late String email;
//   @override
//   void initState() {
//     super.initState();
//     // final args = ModalRoute.of(context)?.settings.arguments;
//     // final currentUser = FirebaseAuth.instance.currentUser;
//     // email = currentUser?.email ?? "unknown@domain.com";
//     context.read<ChatCubit>().getMessages();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // String email = ModalRoute.of(context)!.settings.arguments as String;
//
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(kLogoImage, height: 50),
//             const SizedBox(width: 10),
//             Text(
//               "Chat",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: "dubai",
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: kPrimaryColor,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: BlocBuilder<ChatCubit, ChatState>(
//               builder: (context, state) {
//                 var messagesList = BlocProvider.of<ChatCubit>(
//                   context,
//                 ).messagesList;
//                 return ListView.builder(
//                   reverse: true,
//                   controller: _scrollController,
//                   itemCount: messagesList.length,
//                   itemBuilder: (context, index) {
//                     return messagesList[index].senderId == email
//                         ? ChatBubble(message: messagesList[index])
//                         : ChatBubbleForFriend(message: messagesList[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(18),
//             child: TextField(
//               controller: controller,
//               textInputAction: TextInputAction.send,
//               onSubmitted: (data) {
//                 sendMessageFunc(email);
//               },
//               decoration: InputDecoration(
//                 hintText: "Send Message",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send, color: kPrimaryColor),
//                   onPressed: () {
//                     sendMessageFunc(email);
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void sendMessageFunc(String email) {
//     final text = controller.text.trim();
//     if (text.isEmpty) return;
//
//     BlocProvider.of<ChatCubit>(
//       context,
//     ).sendMessage(message: text, email: email);
//
//     controller.clear();
//
//     _scrollController.animateTo(
//       0,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:publo/constants.dart';
import 'package:publo/cubits/chat_cubit/chat_cubit.dart';
import 'package:publo/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});
  static String id = "ChatView";

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();

  String? email;

  @override
  void initState() {
    super.initState();

    // Delay initialization until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final currentUser = FirebaseAuth.instance.currentUser;

      setState(() {
        email = args as String? ?? currentUser?.email ?? "unknown@domain.com";
      });

      // Fetch messages after email is initialized
      context.read<ChatCubit>().getMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    // If email is not initialized yet, show a loader
    if (email == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(kLogoImage, height: 50),
            const SizedBox(width: 10),
            const Text(
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
                var messagesList = context.read<ChatCubit>().messagesList;
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
    if (email == null) return;

    final text = controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatCubit>().sendMessage(message: text, email: email!);

    controller.clear();

    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
