import 'package:flutter/material.dart';
import 'package:publo/views/update_view.dart';

import '../constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Home",
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UpdateView()),
              );
            },
            icon: Icon(Icons.edit, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UpdateView()),
              );
            },
            icon: Icon(Icons.login, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final item = dataList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: AssetImage(item["image"]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      item["location"],
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
