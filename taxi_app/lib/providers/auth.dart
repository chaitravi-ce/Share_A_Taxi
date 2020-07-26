import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http; 
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
  String token;
  DateTime expiryDate;
  String userId;
  String verificationId;

  bool get isAuth {
    //tryAutoLogin();
    if(token != null){
      return true;
    }
    return false;
  }
  
  signIn(AuthCredential creds){
    print('in signin');
    FirebaseAuth.instance.signInWithCredential(creds);
  }

  Future registerUser(String mobile) async{

    final PhoneVerificationCompleted verified = (AuthCredential authResult){
      print('verified');
      signIn(authResult);
    };

    final PhoneVerificationFailed verifiedFailed = (AuthException authException){
      print('failed');
      print(authException.toString());
    };

    final PhoneCodeSent codeSent = (String verId, [int forceResend]){
      print('code sent');
      this.verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId){
      print('timeout');
      this.verificationId = verId;
    };

    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 60),
      verificationCompleted: verified,
      verificationFailed: verifiedFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }

  Future<void> logout() async{
    token = null;
    userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userId');
    prefs.clear();
  }

}