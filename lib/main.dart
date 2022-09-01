import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter_phone_auth/cubit/auth_cubit/auth_state.dart';
import 'package:flutter_phone_auth/screens/home_screen.dart';
import 'package:flutter_phone_auth/screens/sign_in_screens.dart';
import 'package:flutter_phone_auth/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (oldState, newState) {
              return oldState is AuthInitialState;
            },
            builder: (context, state) {
              if (state is AuthLoggedInState) {
                return const HomeScreen();
              } else if (state is AuthLoggedOutState) {
                return SignInScreen();
              } else {
                return Scaffold();
              }
            },
          )),
    );
  }
}
