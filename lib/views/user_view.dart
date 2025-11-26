import 'package:flutter/material.dart';
import 'package:publo/views/chat_view.dart';
import '../constants.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});
  static String id = "UserView";

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    final users = ModalRoute.of(context)!.settings.arguments as List;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(
          "User Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            fontFamily: "dubai",
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      users[index]["image"],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      users[index]["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, ChatView.id, arguments: "");
                    },
                    icon: Icon(Icons.chat, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
