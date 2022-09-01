import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_auth/cubit/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit() : super(AuthInitialState()) {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      emit(AuthLoggedInState(currentUser));
    } else {
      emit(AuthLoggedOutState());
    }
  }
  String? _verificationId;

  void sendOtp(String number) async {
    emit(AuthLoadingState());
    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      codeSent: ((verificationId, forceResendingToken) => {
            _verificationId = verificationId,
            emit(AuthCodeSentState()),
          }),
      verificationCompleted: (phoneAuthCredential) {
        signInWIthPhone(phoneAuthCredential);
      },
      verificationFailed: (error) {
        emit(AuthErrorState(error.message.toString()));
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOtp(String otp) async {
    emit(AuthLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: otp);
    signInWIthPhone(credential);
  }

  void signInWIthPhone(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }

  void signOut() async {
    await _auth.signOut();
    emit(AuthLoggedOutState());
  }
}
