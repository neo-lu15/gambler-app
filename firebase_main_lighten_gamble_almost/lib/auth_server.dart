import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'home_page.dart';
import 'login_page.dart';

import 'main.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class AuthService{

 

//Determine if the user is authenticated.
  handleAuthState(){
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData){
            print("before HomePage");
            print("account_exist=${account_exist}");
            if(account_exist==1){
                return Container(color: Colors.orange,);
            }else{
              String this_email=FirebaseAuth.instance.currentUser!.email!;
              int at_index=this_email.indexOf("@");
              this_email=this_email.substring(0,at_index);
              global_email=this_email;
              return DefaultTabController(length: 2, child: MyHomePage(title: 'My Casino',email:global_email));
            }
          } else {
            return LoginPage();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    print("In Google check");
    String this_email=googleUser.email;
    int at_index=this_email.indexOf("@");
    this_email=this_email.substring(0,at_index);
    global_email=this_email;
    print("this_email=${this_email}");
    if(!user_list.containsKey(this_email)){      
      print("account not exist");
      account_exist=1;
      print("in determin, account_exist=${account_exist}");
    }else print("account exist");

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

}