

import 'package:firebase_auth_bloc/model/User.dart';
import 'package:flutter/cupertino.dart';

enum AuthStates {UninitializedState, AuthenticatedState, UnAuthenticatedState, CodeSentState}

abstract class AuthState {
  name();
}

class UninitializedState extends AuthState {
  AuthStates name() {
    return AuthStates.UninitializedState;
  }
}

class AuthenticatedState extends AuthState {
  final User user;

  AuthenticatedState({@required this.user});

  @override
  AuthStates name() {
    return AuthStates.AuthenticatedState;
  }
}

class UnAuthenticatedState extends AuthState {

  @override
  AuthStates name() {
    return AuthStates.UnAuthenticatedState;
  }

}

class CodeSentState extends AuthState {

  @override
  AuthStates name() {
    return AuthStates.CodeSentState;
  }
  
}
