import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter_phone_auth/cubit/auth_cubit/auth_state.dart';
import 'package:flutter_phone_auth/screens/sign_in_screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      if (message.data["page"] == "email") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => SignInScreen()),
          ),
        );
      } else if (message.data["page"] == "home") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) => HomeScreen()),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Invalid Page!',
            ),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message.data['myName'].toString(),
          ),
        ),
      );
      log('Message Received ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'App was opened by a notification',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('HomeScreen'),
      ),
      body: Container(
        child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOutState) {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => SignInScreen()),
                  ),
                );
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  BlocProvider.of<AuthCubit>(context).signOut();
                },
                icon: Icon(Icons.exit_to_app),
              );
            },
          ),
        ),
      ),
    );
  }
}
