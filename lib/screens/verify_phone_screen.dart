import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_auth/cubit/auth_cubit/auth_state.dart';
import 'package:flutter_phone_auth/screens/home_screen.dart';

import '../cubit/auth_cubit/auth_cubit.dart';

class VerifyPhoneScreen extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Number'),
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
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "6-Digit OTP",
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 10),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoggedInState) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => const HomeScreen()),
                        ),
                      );
                    } else if (state is AuthErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(state.message.toString()),
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
                          child: const Text('Verify'),
                          onPressed: () {
                            BlocProvider.of<AuthCubit>(context)
                                .verifyOtp(otpController.text);
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
