
import 'package:flutter/material.dart';

enum AuthEvents { AppStart, SendCode, ResendCode, VerifyPhoneNumber }

abstract class AbstractEvent {
  name();
}

class AuthEvent extends AbstractEvent {

  @override
  name() {
    return null;
  }
}


class AppStart extends AuthEvent {
  @override
  AuthEvents name() {
    return AuthEvents.AppStart;
  }
}

class SendCode extends AuthEvent {
  final String phoneNumber;

  SendCode({@required this.phoneNumber});

  @override
  AuthEvents name() {
    return AuthEvents.SendCode;
  }
}


class ResendCode extends AuthEvent {
  @override
  AuthEvents name() {
    return AuthEvents.ResendCode;
  }
}

class VerifyPhoneNumber extends AuthEvent {
  final String smsCode;

  VerifyPhoneNumber({@required this.smsCode});

  @override
  AuthEvents name() {
    return AuthEvents.VerifyPhoneNumber;
  }
}

