import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/venue_cubit/venue_cubit.dart';
import 'user_view.dart';
import '../widgets/custom_form_text_field.dart';
import '../constants.dart';

class VenueView extends StatefulWidget {
  late int index;
  VenueView({super.key, required this.index});
  static String id = "VenueView";

  @override
  State<VenueView> createState() => _VenueViewState();
}

class _VenueViewState extends State<VenueView> {
  String? promo = "";

  @override
  void initState() {
    super.initState();
    print("index");
    print(widget.index);
    context.read<VenueCubit>().fetchVenues();
  }

  @override
  Widget build(BuildContext context) {
    print("asasasa");

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: Text(
          'Venue',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: "dubai",
          ),
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: BlocBuilder<VenueCubit, VenueState>(
        builder: (context, state) {
          if (state is VenueLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VenueFailure) {
            return Center(
              child: Text(
                state.errMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (state is VenueSuccess) {
            final venues = state.venues;

            if (venues.isEmpty) {
              return const Center(
                child: Text(
                  "No venues found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            // Display first venue for example
            final data = venues[widget.index];
            print("object");
            print("${data['image']}");

            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CachedNetworkImage(imageUrl: data['image']),
                ),

                const SizedBox(height: 20),
                Text(
                  data['title'] ?? "No Title",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  data['address'] ?? "No Address",
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),
                // const Text(
                //   "Verification Code",
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 18,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   child: CustomFormTextField(
                    //     onChanged: (value) {
                    //       promo = value;
                    //     },
                    //     hintText: "Enter your code",
                    //   ),
                    // ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (promo == null || promo!.isEmpty) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text("Please enter promo code"),
                          //   ),
                          // );
                          return;
                        }
                        if (promo ==
                            (data['verification_code'] ?? "").toString()) {
                          final venueId = data["id"];
                          final user = FirebaseAuth.instance.currentUser!;

                          FirebaseFirestore.instance
                              .collection('manu')
                              .doc(venueId)
                              .collection('users')
                              .doc(user.uid)
                              .set({
                                "uid": user.uid,
                                "name": user.displayName ?? "User",
                                "email": user.email ?? "",
                                "photoUrl": user.photoURL ?? "",
                                "joined_at": FieldValue.serverTimestamp(),
                              })
                              .then((_) {
                                Navigator.pushNamed(
                                  context,
                                  UserView.id,
                                  arguments: venueId,
                                );
                              });
                        }
                        // if (promo ==
                        //     (data['verification_code'] ?? "").toString()) {
                        //   Navigator.pushNamed(context, UserView.id);
                        // }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Invalid promo code")),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Add User"),
                          SizedBox(width: 8),
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
