import 'package:firebase_auth_bloc/bloc/AuthEvents.dart';
import 'package:firebase_auth_bloc/bloc/AuthStates.dart';
import 'package:firebase_auth_bloc/model/User.dart';
import 'package:firebase_auth_bloc/repository/FirebaseAuthRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuthRepo _firebaseAuthRepo;

  AuthBloc({@required FirebaseAuthRepo firebaseAuthRepo})
      : assert(firebaseAuthRepo != null),
        this._firebaseAuthRepo = firebaseAuthRepo;

  @override
  AuthState get initialState => UninitializedState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    switch (event.name()) {
      case AuthEvents.AppStart:
        yield* mapAppStartToState();
        break;
      case AuthEvents.SendCode:
        yield* mapSendCodeState(event);
        break;
      case AuthEvents.ResendCode:
        yield* mapResendCodeState(event);
        break;
      case AuthEvents.VerifyPhoneNumber:
        yield* mapVerifyPhoneNumberState(event);
        break;
    }
  }

  Stream<AuthState> mapAppStartToState() async* {
    try {
      final isAuthenticated = await _firebaseAuthRepo.isAuthenticated();
      if (isAuthenticated) {
        yield AuthenticatedState(user: await _firebaseAuthRepo.getUser());
      } else {
        yield UnAuthenticatedState();
      }
    } catch (_) {
      yield UnAuthenticatedState();
    }
  }

  Stream<AuthState> mapSendCodeState(AuthEvent event) async* {
    await _firebaseAuthRepo.verifyPhoneNumber((event as SendCode).phoneNumber);
    yield CodeSentState();
  }

  Stream<AuthState> mapResendCodeState(AuthEvent event) async* {
    await _firebaseAuthRepo.verifyPhoneNumber((event as SendCode).phoneNumber);
    yield CodeSentState();
  }

  Stream<AuthState> mapVerifyPhoneNumberState(AuthEvent event) async* {
    User _user = await _firebaseAuthRepo
        .signInWithSmsCode((event as VerifyPhoneNumber).smsCode);
    yield AuthenticatedState(user: _user);
  }
}
