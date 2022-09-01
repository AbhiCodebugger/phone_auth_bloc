import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_auth/cubit/auth_cubit/auth_cubit.dart';
import 'package:flutter_phone_auth/cubit/auth_cubit/auth_state.dart';
import 'package:flutter_phone_auth/screens/verify_phone_screen.dart';

class SignInScreen extends StatelessWidget {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In with Phone'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: phoneController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Phone Number",
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 10),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthCodeSentState) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => VerifyPhoneScreen()),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          child: const Text('Sign In'),
                          onPressed: () {
                            String phoneNumber = "+91${phoneController.text}";
                            BlocProvider.of<AuthCubit>(context)
                                .sendOtp(phoneNumber);
                          }),
                    );
                  },
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
