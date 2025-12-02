import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:publo/views/home_users.dart';
import 'package:publo/views/update_view.dart';
import 'package:publo/views/user_view.dart';
import 'package:publo/views/venue_view.dart';
import '../constants.dart';
import '../cubits/venue_cubit/venue_cubit.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static String id = "HomeView";

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List dataList = [
    {
      "image": "assets/images/Just BLR.png",
      "name": "Just BLR",
      "location": "Brigade Road",
    },
    {
      "image": "assets/images/Toit Brewpub.jpg",
      "name": "Toit Brewpub",
      "location": "Indiranagar",
    },
    {
      "image": "assets/images/Arbor Brewing Company.png",
      "name": "Arbor Brewing Company",
      "location": "MG Road / Ashok Nagar",
    },
    {
      "image": "assets/images/The Bier Library.jpg",
      "name": "The Bier Library",
      "location": "Koramangala",
    },
    {
      "image": "assets/images/BigPitcher.jpg",
      "name": "Big Pitcher (Old Airport Road)",
      "location": "Old Airport Road",
    },
    {
      "image": "assets/images/big-pitcher.jpg",
      "name": "Big Pitcher (Sarjapur)",
      "location": "Sarjapur Road",
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<VenueCubit>().fetchVenues();
  }

  int currentIndex = 0;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, LoginView.id);
              },
              child: Text("Yes", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      backgroundColor: kPrimaryColor,

      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Welcome",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w500,
            fontFamily: "dubai",
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ],
      ),

      // actions: [
      //   Builder(
      //     builder: (context) {
      //       return IconButton(
      //         icon: Icon(Icons.more_vert, color: Colors.white),
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer();
      //         },
      //       );
      //     },
      //   ),
      body: BlocBuilder<VenueCubit, VenueState>(
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (state is VenueFailure) {
            return Center(
              child: Text(
                state.errMessage,
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          if (state is VenueSuccess) {
            final venues = state.venues;

            return ListView.builder(
              itemCount: venues.length,
              itemBuilder: (context, index) {
                final item = venues[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VenueView(index: index),
                          ),
                        );
                      },
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: AssetImage(dataList[index]["image"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 5),
                    Text(
                      item["title"].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      item["address"].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            );
          }
          return const SizedBox();
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() => currentIndex = value);

          if (value == 1) {
            Navigator.pushNamed(context, HomeUserView.id);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: kPrimaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/person1.jpg"),
                ),
                SizedBox(height: 10),
                Text(
                  "Ashu Khare",
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? "",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          _buildMenuItem(Icons.person, "View Profile", () {
            Navigator.pushNamed(context, UserView.id);
          }),

          // _buildMenuItem(Icons.camera_alt, "Edit Profile Picture", () {
          //   Navigator.pushNamed(context, UpdateView.id);
          // }),
          _buildMenuItem(Icons.badge, "Update Profile", () {
            Navigator.pushNamed(context, UpdateView.id);
          }),

          // _buildMenuItem(Icons.email, "Edit Email", () {
          //   Navigator.pushNamed(context, UpdateView.id);
          // }),
          //
          // _buildMenuItem(Icons.info_outline, "Edit Bio", () {
          //   Navigator.pushNamed(context, UpdateView.id);
          // }),
          //
          // _buildMenuItem(Icons.phone, "Edit Phone Number", () {
          //   Navigator.pushNamed(context, UpdateView.id);
          // }),
          //
          _buildMenuItem(Icons.history, "View My Past Venue", () {
            Navigator.pushNamed(context, HomeUserView.id);
          }),
          Divider(color: Colors.white54),

          _buildMenuItem(Icons.logout, "Logout", () {
            Navigator.pop(context);
            _showLogoutDialog(context);
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
    );
  }
}
