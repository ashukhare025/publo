import 'package:publo/helper/show_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../cubits/chat_cubit/chat_cubit.dart';
import '../cubits/update_cubit/update_cubit.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_text_field.dart';
import 'chat_view.dart';
import 'home_view.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UpdateView extends StatefulWidget {
  const UpdateView({super.key});
  static String id = "UpdateView";

  @override
  State<UpdateView> createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  String? email;
  String? username;
  String? number;
  String? Bio;
  bool isLoading = false;

  File? profileImage;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateCubit, UpdateState>(
      listener: (context, state) {
        if (state is UpdateLoading) {
          isLoading = true;
        } else if (state is UpdateSuccess) {
          // BlocProvider.of<ChatCubit>(context).getMessages();
          Navigator.pushNamed(context, HomeView.id);
          isLoading = false;
        }
        // else if (state is UpdateFailure) {
        //   showSnackBar(context, state.errMessage);
        //   isLoading = false;
        // }
      },
      builder: (context, state) => ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Publo",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'dubai',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Text(
                        "Update an account",
                        style: TextStyle(
                          color: Color(0xff00ff99),
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'dubai',
                        ),
                      ),
                      // const Text(
                      //   "Connect and chat with your friends today!",
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 16,
                      //     fontFamily: "dubai",
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Stack(
                      children: [
                        // Main Profile Circle
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white24,
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : null,
                          child: profileImage == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : null,
                        ),

                        // Edit Button (Camera Icon)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              final picker = ImagePicker();
                              final picked = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 70,
                              );

                              if (picked != null) {
                                setState(() {
                                  profileImage = File(picked.path);
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.greenAccent,
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "User name",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomFormTextField(
                    onChanged: (data) {
                      username = data;
                    },
                    hintText: "enter your username",
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomFormTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    hintText: "example@gmail.com",
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone number",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomFormTextField(
                    onChanged: (data) {
                      number = data;
                    },
                    icon: Icons.phone,
                    inverseIcon: Icons.phone,
                    hintText: "enter your number",
                  ),

                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bio",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 10),
                  // TextFormField(
                  //   onChanged: (data) {
                  //     Bio = data;
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: "Enter your Bio",
                  //     border: OutlineInputBorder(),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.white),
                  //     ),
                  //     errorBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.red),
                  //     ),
                  //   ),
                  // ),
                  CustomFormTextField(
                    onChanged: (data) {
                      username = data;
                    },
                    hintText: "Enter your bio",
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<UpdateCubit>(context).registerUser(
                          email: email!,
                          username: username!,
                          number: number!,
                          bio: Bio!,
                        );
                      }
                    },
                    title: "Update",
                  ),
                  SizedBox(height: 10),
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        BlocProvider.of<UpdateCubit>(context).registerUser(
                          email: email!,
                          username: username!,
                          number: number!,
                          bio: Bio!,
                        );
                      }
                    },
                    title: "Logout",
                  ),
                  const SizedBox(height: 12),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text(
                  //       "Already have an account? ",
                  //       style: TextStyle(color: Colors.white, fontSize: 18),
                  //     ),
                  //     GestureDetector(
                  //       onTap: () {
                  //         Navigator.pop(context);
                  //       },
                  //       child: const Text(
                  //         'Login',
                  //         style: TextStyle(
                  //           color: Color(0xff00ff99),
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w700,
                  //           fontFamily: "dubai",
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 75),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
