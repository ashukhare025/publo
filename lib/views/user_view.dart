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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:publo/views/chat_view.dart';
import '../constants.dart';
import '../cubits/user_cubit/user_cubit.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});
  static String id = "UserView";
  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    // final List users =
    //     (ModalRoute.of(context)?.settings.arguments as List?) ?? [];
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(
          (("Users")),
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

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(users[index].image),
                  ),
                  title: Text(users[index].name),
                  // trailing: Row(
                  //   children: [
                  //     IconButton(onPressed: () {}, icon: (Icons.chatIcon)),
                  //     IconButton(onPressed: () {}, icon: ()),
                  //   ],
                  // ),
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
