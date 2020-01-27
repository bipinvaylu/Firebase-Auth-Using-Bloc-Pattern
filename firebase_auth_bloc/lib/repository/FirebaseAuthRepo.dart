import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_bloc/model/User.dart';
import 'package:flutter/cupertino.dart';

class FirebaseAuthRepo {
  FirebaseAuth _firebaseAuth;
  String _verificationCode = "";

  FirebaseAuthRepo({FirebaseAuth firebaseAuth}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        timeout: Duration(seconds: 0),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential),
        verificationFailed: (authException) =>
            _verificationFailed(authException),
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId));
  }

  Future<User> getUser() async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    return User.fromFirebaseUser(firebaseUser);
  }

  Future<bool> isAuthenticated() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  void _verificationComplete(AuthCredential authCredential) {}

  void _smsCodeSent(String verificationCode, List<int> code) {
    this._verificationCode = verificationCode;
  }

  String _verificationFailed(AuthException authException) {
    return authException.message;
  }

  void _codeAutoRetrievalTimeout(String verificationCode) {
    this._verificationCode = verificationCode;
  }

  Future<User> signInWithSmsCode(String smsCode) async {
    debugPrint("verif in sign in" + _verificationCode);
    debugPrint("smsCode" + smsCode.toString());

    User _user;
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationCode, smsCode: smsCode);
    _firebaseAuth.signInWithCredential(authCredential).then((authResult) {
      _user = User.fromFirebaseUser(authResult.user);
    });
  }
}
