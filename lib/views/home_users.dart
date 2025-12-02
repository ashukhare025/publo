import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:publo/views/chat_view.dart';
import '../constants.dart';
import '../cubits/user_cubit/user_cubit.dart';


class HomeUserView extends StatelessWidget {
  static String id = "HomeUserView";

  @override
  Widget build(BuildContext context) {


    context.read<UserCubit>().fetchContacts();

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(
          (("Chat Users")),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            fontFamily: "dubai",
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is UserFailure) {
            return Center(child: Text(state.errorMessage));
          }

          if (state is UserSuccess) {
            final users = state.users;

            // ✅ If empty → show message
            if (users.isEmpty) {
              return Center(
                child: Text(
                  "No users in contact",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              );
            }

            // ✅ Otherwise show the list
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: (user.image != null && user.image.isNotEmpty)
                        ? CachedNetworkImageProvider(user.image)
                        : const AssetImage("assets/images/profile.png") as ImageProvider,
                  ),


                  title: Text(
                    user.name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),

                  subtitle: Text(
                    user.email,
                    style: TextStyle(color: Colors.white),
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      if (user.status == "pending" && user.requestBy != FirebaseAuth.instance.currentUser!.uid) ...[
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () async {
                            await context.read<UserCubit>().acceptContact(user.uid);
                            await context.read<UserCubit>().fetchContacts();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () async {
                            await context.read<UserCubit>().rejectContact(user.uid);
                            await context.read<UserCubit>().fetchContacts();
                          },
                        ),
                      ],

                      if (user.status == "accepted")
                        IconButton(
                          icon: Icon(Icons.chat, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatView(
                                  receiverId: user.uid,
                                  receiverName: user.name,
                                  receiverImage: user.image,
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          }

          return SizedBox.shrink();
        },
      ),

    );
  }
}