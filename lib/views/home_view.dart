import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:publo/views/update_view.dart';
import 'package:publo/views/user_view.dart';
import 'package:publo/views/venue_view.dart';
import '../constants.dart';
import '../cubits/venue_cubit/venue_cubit.dart';
import 'chat_view.dart';
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
    {
      "image": "assets/images/BygBrewskiBrewing.png",
      "name": "Byg Brewski Brewing Co (Hennur)",
      "location": "Hennur",
    },
    {
      "image": "assets/images/BygBrewskiBrewingSarjapur.png",
      "name": "Byg Brewski Brewing Co (Sarjapur)",
      "location": "Sarjapur / Bellandur",
    },
    {
      "image": "assets/images/StoriesBrewery&Kitchen.png",
      "name": "Stories Brewery & Kitchen",
      "location": "JP Nagar",
    },
    {
      "image": "assets/images/BLRBrewingCo.png",
      "name": "BLR Brewing Co (Kanakapura)",
      "location": "Kanakapura Road",
    },
    {
      "image": "assets/images/BLRBrewingCo(Electronic City).png",
      "name": "BLR Brewing Co (Electronic City)",
      "location": "Electronic City",
    },
    {
      "image": "assets/images/District6PubBrewery.jpg",
      "name": "District 6 Pub Brewery",
      "location": "Malleshwaram",
    },
    {
      "image": "assets/images/Communiti.jpg",
      "name": "Communiti",
      "location": " Brigade Road",
    },
    {
      "image": "assets/images/Gilly’s Restobar.jpg",
      "name": "Gilly’s Restobar",
      "location": "Koramangala",
    },
    {
      "image": "assets/images/Fenny’s Lounge & Kitchen.jpg",
      "name": "Fenny’s Lounge & Kitchen",
      "location": " Koramangala 7th Block",
    },
    {
      "image": "assets/images/Hammered.png",
      "name": "Hammered",
      "location": "New BEL Road",
    },
    {
      "image": "assets/images/IronhillBengaluru.jpg",
      "name": "Ironhill Bengaluru",
      "location": "Marathahalli",
    },
    {
      "image": "assets/images/Bob’s Bar.png",
      "name": "Bob’s Bar",
      "location": "Indiranagar",
    },
    {
      "image": "assets/images/Windmills Craftworks.jpg",
      "name": "Windmills Craftworks",
      "location": "Whitefield",
    },
    {
      "image": "assets/images/Red Rhino.jpg",
      "name": "Red Rhino",
      "location": "Whitefield",
    },
  ];

  final Map<int, List<Map<String, dynamic>>> venueUsers = {
    0: [
      {"name": "Amit Sharma", "image": "assets/images/person1.jpg"},
      {"name": "Rahul Sharma", "image": "assets/images/person3.jpg"},
      {"name": "Ram Singh", "image": "assets/images/person1.jpg"},
      {"name": "David Watson", "image": "assets/images/person3.jpg"},
    ],
    1: [
      {"name": "Priya Singh", "image": "assets/images/person1.jpg"},
      {"name": "Neha Antiwar", "image": "assets/images/person3.jpg"},
    ],
    2: [
      {"name": "John Doe", "image": "assets/images/person1.jpg"},
    ],
  };

  // int selectedVenueId = 0;

  @override
  void initState() {
    super.initState();
    context.read<VenueCubit>().fetchVenues();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          IconButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(20, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              Navigator.pushNamed(context, UpdateView.id);
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginView.id);
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),

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
                        print(VenueView.id);
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
                            image: (dataList[index]["image"] ?? "").isEmpty
                                ? AssetImage("assets/images/placeholder.png")
                                : AssetImage(dataList[index]["image"])
                                      as ImageProvider,
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
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() => currentIndex = value);

          if (value == 1) {
            Navigator.pushNamed(context, UserView.id);
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        ],
      ),
    );
  }
}
