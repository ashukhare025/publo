// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../constants.dart';
// import '../cubits/user_cubit/user_cubit.dart';
// // import '../services/firestore_service.dart';
//
// class UserView extends StatefulWidget {
//   static String id = "UserView";
//
//   @override
//   State<UserView> createState() => _UserViewState();
// }
//
// class _UserViewState extends State<UserView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<UserCubit>().fetchUsers();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kPrimaryColor,
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         title: const Text("Users"),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<UserCubit, UserState>(
//         builder: (context, state) {
//           if (state is UserLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is UserFailure) {
//             return Center(child: Text("Error: ${state.errorMessage}"));
//           } else if (state is UserSuccess) {
//             final users = state.users;
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final user = users[index];
//                 return Row(
//                   children: [
//                     Image.asset(user.image),
//                     Text(user.name),
//                     IconButton(onPressed: () {}, icon: Icon(user.chatIcon)),
//                     IconButton(onPressed: () {}, icon: Icon(user.personIcon)),
//                   ],
//                 );
//
//                 //   ListTile(
//                 //   title: Text(user.name),
//                 //   subtitle: Text(user.image),
//                 //   leading: const Icon(Icons.person),
//                 //   trailing: Icon(Icons.chat),
//                 // );
//               },
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:publo/views/chat_view.dart';
import 'package:publo/views/home_view.dart';
import '../constants.dart';
import '../cubits/user_cubit/user_cubit.dart';

//
// class UserView extends StatelessWidget {
//   static String id = "UserView";
//
//   @override
//   Widget build(BuildContext context) {
//     final venueId = ModalRoute.of(context)!.settings.arguments as String?;
//
//     if (venueId == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("Users")),
//         body: Center(child: Text("❌ Error: Venue ID missing")),
//       );
//     }
//
//     context.read<UserCubit>().fetchVenueUsers(venueId);
//
//     return Scaffold(
//       appBar: AppBar(title: Text("Users")),
//       body: BlocBuilder<UserCubit, UserState>(
//         builder: (context, state) {
//           if (state is UserLoading)
//             return const Center(child: CircularProgressIndicator());
//
//           if (state is UserFailure)
//             return Center(child: Text(state.errorMessage));
//
//           if (state is UserSuccess) {
//             final users = state.users;
//
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (_, i) {
//                 final user = users[i];
//
//                 return ListTile(
//                   leading: user.image.isNotEmpty
//                       ? CircleAvatar(backgroundImage: NetworkImage(user.image))
//                       : const CircleAvatar(child: Icon(Icons.person)),
//                   title: Text(user.name),
//                   subtitle: Text(user.email),
//                   onTap: () {
//                     Navigator.pushNamed(
//                       context,
//                       ChatView.id,
//                       arguments: {
//                         "receiverId": user.uid,
//                         "receiverName": user.name,
//                         "receiverImage": user.image,
//                       },
//                     );
//                   },
//                 );
//               },
//             );
//           }
//
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }


class UserView extends StatelessWidget {
  static String id = "UserView";

  @override
  Widget build(BuildContext context) {
    final venueId = ModalRoute.of(context)!.settings.arguments as String?;

    if (venueId == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Users")),
        body: Center(child: Text("❌ Error: Venue ID missing")),
      );
    }

    context.read<UserCubit>().fetchVenueUsers(venueId);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Users",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            fontFamily: "dubai",
          ),
        ),
        centerTitle: true,
      ),

      /// ✅ LISTEN FOR CONTACT ADDED EVENT
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserContactAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Contact added successfully!")),
            );

            /// Navigate after contact is added
            Navigator.pushReplacementNamed(context, HomeView.id);
          }
        },

        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is UserFailure) {
              return Center(child: Text(state.errorMessage));
            }

            if (state is UserSuccess) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];

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

                    trailing: IconButton(
                      icon: const Icon(Icons.person_add_alt_1,
                          color: Colors.white),
                      onPressed: () {
                        context.read<UserCubit>().addToContacts(user);
                      },
                    ),
                  );
                },
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}


// class UserView extends StatelessWidget {
//   static String id = "UserView";
//
//   @override
//   Widget build(BuildContext context) {
//     final venueId = ModalRoute.of(context)!.settings.arguments as String?;
//
//     if (venueId == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("Users")),
//         body: Center(child: Text("❌ Error: Venue ID missing")),
//       );
//     }
//
//     context.read<UserCubit>().fetchVenueUsers(venueId);
//     return Scaffold(
//       backgroundColor: kPrimaryColor,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: kPrimaryColor,
//         title: Text(
//           (("Users")),
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.white,
//             fontFamily: "dubai",
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: BlocBuilder<UserCubit, UserState>(
//         builder: (context, state) {
//           if (state is UserLoading) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (state is UserFailure) {
//             return Center(child: Text(state.errorMessage));
//           }
//
//           if (state is UserSuccess) {
//             // final users = state.users;
//             return ListView.builder(
//               itemCount: state.users.length,
//               itemBuilder: (context, index) {
//                 final user = state.users[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     radius: 28,
//                     // backgroundImage: user.image.isEmpty
//                     //     ? AssetImage("assets/images/placeholder.png")
//                     //           as ImageProvider
//                     //     : NetworkImage(user.image),
//                     child: CachedNetworkImage(imageUrl: user.image),
//                   ),
//
//                   // title: Text(state.users[index].name),
//                   title: Text(
//                     user.name,
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                   // subtitle: Text(
//                   //   user.email,
//                   //   style: TextStyle(color: Colors.white70),
//                   // ),
//                   subtitle: Text(
//                     user.email,
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   // onTap :
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//
//
//                       IconButton(
//                         icon: const Icon(
//                           Icons.person_add_alt_1,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           context.read<UserCubit>().addToContacts(user);
//
//                           Navigator.pushOffNamed(context, HomeView.id);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text("${user.name} added to contacts"),
//                             ),
//                           );
//                         },
//                       ),
//
//                     ],
//                   ),
//
//                   // trailing: Row(
//                   //   children: [
//                   //     IconButton(onPressed: () {}, icon: (Icons.chatIcon)),
//                   //     IconButton(onPressed: () {}, icon: ()),
//                   //   ],
//                   // ),
//                 );
//               },
//             );
//           }
//
//           return SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }
