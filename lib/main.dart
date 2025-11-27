import 'package:firebase_auth/firebase_auth.dart';
import 'package:publo/cubits/chat_cubit/chat_cubit.dart';
import 'package:publo/cubits/login_cubit/login_cubit.dart';
import 'package:publo/cubits/update_cubit/update_cubit.dart';
import 'package:publo/cubits/venue_cubit/venue_cubit.dart';
import 'package:publo/views/chat_view.dart';
import 'package:publo/views/home_view.dart';
import 'package:publo/views/login_view.dart';
import 'package:publo/views/signup_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:publo/views/update_view.dart';
import 'package:publo/views/user_view.dart';
import 'package:publo/views/venue_view.dart';
import 'cubits/home_cubit/home_cubit.dart';
import 'cubits/signup_cubit/signup_cubit.dart';
import 'cubits/user_cubit/user_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    await FirebaseAuth.instance.currentUser?.reload();
    print("🔥 Firebase Ready on Device");
  } catch (e) {
    print("❌ Firebase NOT working on this device: $e");
  }

  runApp(MindBridge());
}

class MindBridge extends StatelessWidget {
  const MindBridge({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => SignupCubit()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => UpdateCubit()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => VenueCubit()),
        BlocProvider(create: (context) => UserCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          LoginView.id: (context) => LoginView(),
          SignupView.id: (context) => SignupView(),
          ChatView.id: (context) => ChatView(),
          UpdateView.id: (context) => UpdateView(),
          HomeView.id: (context) => HomeView(),
          VenueView.id: (context) => VenueView(),
          UserView.id: (context) => UserView(),
        },
        initialRoute: LoginView.id,
      ),
    );
  }
}

//id("com.google.gms.google-services") version "4.4.4" apply false
//id("com.android.application")
//id("com.google.gms.google-services")
//implementation(platform("com.google.firebase:firebase-bom:34.6.0"))
//implementation("com.google.firebase:firebase-analytics")
