import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nomad/home.dart';
import 'package:nomad/login.dart';
import 'package:nomad/utils.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Text('Sign up',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: dark,
                          fontSize: 40)),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 50, 30, 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
                              prefixIcon: Icon(Icons.person,
                                  size: 30, color: veryLight),
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                  color: veryLight,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300)),
                          controller: name,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Name can\'t be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
                              prefixIcon:
                                  Icon(Icons.email, size: 30, color: veryLight),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  color: veryLight,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300)),
                          controller: email,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Email can\'t be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide()),
                            prefixIcon:
                                Icon(Icons.lock, size: 30, color: veryLight),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: veryLight,
                                fontSize: 18,
                                fontWeight: FontWeight.w300),
                          ),
                          obscureText: true,
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password can\'t be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email.text.trim(),
                                password: password.text.trim())
                            .then((value) async {
                          if (value.user != null) {
                            await FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({
                              "uid": FirebaseAuth.instance.currentUser!.uid,
                              "name": name.text,
                              "email": email.text,
                              "profilephoto": null,
                              "accountCreated": DateTime.now()
                            }, SetOptions(merge: true));

                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('email', email.text.trim());

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Home()),
                                (Route<dynamic> route) => false);
                          }
                        });
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: dark),
                  child: Text('Sign Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25)),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Already have an account? ',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: veryLight,
                            fontSize: 18)),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text('Login',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: veryLight,
                              fontSize: 20)),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Text('Or', style: TextStyle(color: veryLight, fontSize: 16)),
                Text('SignIn using Google',
                    style: TextStyle(color: veryLight, fontSize: 16)),
                SizedBox(height: 20),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    try {
                      final GoogleSignInAccount? googleSignInAccount =
                          await _googleSignIn.signIn();
                      final GoogleSignInAuthentication
                          googleSignInAuthentication =
                          await googleSignInAccount!.authentication;
                      final AuthCredential credential =
                          GoogleAuthProvider.credential(
                        accessToken: googleSignInAuthentication.accessToken,
                        idToken: googleSignInAuthentication.idToken,
                      );
                      await FirebaseAuth.instance
                          .signInWithCredential(credential)
                          .then((value) async {
                        if (value.additionalUserInfo!.isNewUser) {
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({
                            "uid": FirebaseAuth.instance.currentUser!.uid,
                            "name": value.user!.displayName,
                            "email": value.user!.email,
                            "profilephoto": null,
                            "accountCreated": DateTime.now()
                          }, SetOptions(merge: true));
                        }
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setString('email', value.user!.email.toString());

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (Route<dynamic> route) => false);
                      });
                    } on FirebaseAuthException catch (e) {
                      print(e.message);
                      throw e;
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white),
                    child: Center(
                      child: Image.asset(
                        'assets/google.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}