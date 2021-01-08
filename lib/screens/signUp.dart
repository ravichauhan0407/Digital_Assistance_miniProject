import 'package:Digital_Assistance/database/sharedPrefference.dart';
import 'package:Digital_Assistance/screens/registerAsServiceProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  authChange() async {
    _auth.authStateChanges().listen((event) async {
      if (event != null) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) {
          return RegisterAsSP();
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
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 300,
                child: appLogo(),
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.teal[200]),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[200]))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.teal[200]),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[200]))),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.teal[200]),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[200])),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[200]))),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: RaisedButton(
                padding: EdgeInsets.zero,
                onPressed: signUpwithEmailAndPassword,
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: 4.0),
                  child: Text(
                    'SignUp',
                    style: TextStyle(fontSize: 25),
                  ),
                  decoration:
                      BoxDecoration(gradient: LinearGradient(colors: appColor)),
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
    );
  }

  signUpwithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: this.emailController.text,
              password: this.passwordController.text);
      if (userCredential != null) {
        Sharedpref.saveUserNamePreference(this.nameController.text);
        userCredential.user
            .updateProfile(displayName: this.nameController.text);
      }
    } on FirebaseAuthException catch (e) {
      errorDialogue(e.code.toString(), context);
    }
  }
}
