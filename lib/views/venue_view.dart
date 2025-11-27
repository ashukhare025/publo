import 'package:flutter/material.dart';
import 'package:publo/views/user_view.dart';

import '../constants.dart';
import '../widgets/custom_form_text_field.dart';

class VenueView extends StatefulWidget {
  const VenueView({super.key});
  static String id = "VenueView";

  @override
  State<VenueView> createState() => _VenueViewState();
}

class _VenueViewState extends State<VenueView> {
  String? promo = "";
  @override
  void initState() {
    super.initState();
    promo = "";
  }

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

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Text(
          "Venue",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            fontFamily: "dubai",
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 2),
                image: DecorationImage(
                  image: AssetImage(data["image"]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["name"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: "dubai",
                  ),
                ),
                Text(
                  data["location"],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontFamily: "dubai",
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Verification Code",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: CustomFormTextField(
                      onChanged: (value) {
                        promo = value;
                      },
                      hintText: "Enter your code",
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (promo == null || promo!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter promo code")),
                        );
                        return;
                      }
                      if (promo == "1234") {
                        Navigator.pushNamed(
                          context,
                          UserView.id,
                          arguments: venueUsers[data["venueId"]],
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter promo code")),
                        );
                      }

                      // Navigator.pushNamed(context, UserView.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Apply",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
