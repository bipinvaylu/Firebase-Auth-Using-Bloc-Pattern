import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_bloc/bloc/auth_bloc.dart';
import 'package:firebase_auth_bloc/repository/FirebaseAuthRepo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Firebase Auth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthBloc _authBloc = AuthBloc(
    firebaseAuthRepo: FirebaseAuthRepo(
      firebaseAuth: FirebaseAuth.instance,
    ),
  );

  TextEditingController phoneNumController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: BlocBuilder(
            bloc: _authBloc,
            builder: (BuildContext context, AuthState authState) {
              return _body(context, authState);
            }),
      ),
    );
  }

  /// Method
  Widget _body(BuildContext context, AuthState authState) {
    Widget widget;

    switch (authState.name()) {
      case AuthStates.UninitializedState:
        this._authBloc.add(AppStart());
        widget = Center(
            child: CircularProgressIndicator(
          value: null, // drawing of the circle does not depend on any value
          strokeWidth: 5.0, // line width
        ));
        break;
      case AuthStates.CodeSentState:
        debugPrint("CodeSendState");
        // After sms code is sent to the user, display the widget to enter sms code
        widget = _getSmsCode(context);
        break;
      case AuthStates.UnAuthenticatedState:
        // If user is not authenticated, then display the screen to enter phone number to authenticate the user.
        widget = _getUserPhone(context);
        break;
      case AuthStates.AuthenticatedState:
        debugPrint("AuthenticatedState");
        // Check if the user is in group, if not show screen that will display Group Options
        // IF the user is already in a group, show the screen that displays booked slots and ability to add new slot
        widget = Text(
          "User authenticated successfully.",
          textScaleFactor: 1.5,
        );
        break;
    }
    return widget;
  }

  /// Method that returns a widget with textfield+button to get the phone number from the user
  Widget _getUserPhone(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          expands: false,
          controller: phoneNumController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              labelText: "Enter your phone number",
              alignLabelWithHint: true,
              prefixText: "+91",
              //border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder()),
        ),
        FlatButton(
          child: Text("Send code"),
          onPressed: () => _sendCode(phoneNumController.text),
        ),
      ],
    );
  } // end of _getUserPhone

  /// method to verify phone number and handle phone auth
  _sendCode(String phoneNumber) async {
    this._authBloc.add(SendCode(phoneNumber: phoneNumber));
  } // end of _sendCode

  /// Method that returns a widget with textfield+button to get the SMS code that was sent to the user
  Widget _getSmsCode(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "SMS code was sent to " + phoneNumController.text.toString() + "\n",
          textScaleFactor: 1.5,
        ),
        TextField(
          controller: codeController,
          decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: "Enter Code",
              focusedBorder: OutlineInputBorder()),
        ),
        FlatButton(
          child: Text("Verify Phone Number"),
          onPressed: () => _signInWithCode(codeController.text),
        ),
        FlatButton(
          child: Text("Resend Code"),
          onPressed: () => _getUserPhone(context),
        ),
      ],
    );
  } // end of _getSmsCode

  // smsCode is the code that is sent to the users phone that they enter in the textfield
  _signInWithCode(String smsCode) {
    // now that the user has entered the sms code, its time to signIn the user with their phone number
    this._authBloc.add(VerifyPhoneNumber(
        smsCode:
            smsCode)); // this event will either send back Authenticated or UnAuthenticated
  } // end of _sendCode

}
