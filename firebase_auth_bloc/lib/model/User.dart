import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User extends Equatable {
  final String userId;
  final String userName;
  final String phoneNum;

  User(this.userId, this.userName, this.phoneNum);

  factory User.fromFirebaseUser(FirebaseUser firebaseUser) {
    return User(
      firebaseUser.uid,
      firebaseUser.displayName,
      firebaseUser.phoneNumber,
    );
  }



  @override
  List<Object> get props => [this.userId, this.userName, this.phoneNum];

}
