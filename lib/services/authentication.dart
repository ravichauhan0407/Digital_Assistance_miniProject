import 'package:Digital_Assistance/Constants.dart';
import 'package:Digital_Assistance/screens/homePage.dart';
import 'package:Digital_Assistance/screens/signIn.dart';
import 'package:Digital_Assistance/screens/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  authChange() async {
    _auth.authStateChanges().listen((event) async {
      if (event != null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }), (route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    authChange();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  width: 300,
                  height: 400,
                  child: appLogo(),
                ),
              ),
              SliverToBoxAdapter(
                child: RaisedButton(
                  padding: EdgeInsets.zero,
                  onPressed: navigateToSignIn,
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding, vertical: 4.0),
                    child: Text(
                      'Already has an Account?',
                      style: TextStyle(fontSize: 25),
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: appColor)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverToBoxAdapter(
                child: RaisedButton(
                  padding: EdgeInsets.zero,
                  onPressed: navigateToSignUp,
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding, vertical: 4.0),
                    child: Text(
                      'Register here',
                      style: TextStyle(fontSize: 25),
                    ),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: appColor)),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  navigateToSignIn() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignIn();
    }));
  }

  navigateToSignUp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SignUp();
    }));
  }
}
