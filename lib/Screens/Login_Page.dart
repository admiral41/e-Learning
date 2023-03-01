import 'package:elearning/Screens/Admin_dashboard.dart';
import 'package:elearning/Screens/Forgot_password.dart';
import 'package:elearning/Screens/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Widgets/BouncingButton.dart';
import 'RequestLogin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation, muchDelayedAnimation, LeftCurve;
  late AnimationController animationController;

  // _formField chai email ra password ko lagi
  final _formField = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //_formkey for forgot passworrd ?
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));

    LeftCurve = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut)));
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void login() async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = authResult.user;
      assert(user != null);
      assert(await user?.getIdToken() != null);
      print("Successfully signed in user: ${user?.email}");

// Check if the user is an admin
      final adminSnapshot = await _firestore
          .collection("admins").doc(user?.uid).get();
      if (adminSnapshot.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AdminDashboard(),
          ),
        );
        return;
      }
// Check if the user is a regular user
      final userSnapshot = await _firestore
          .collection("users").doc(user?.uid).get();
      if (userSnapshot.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => UserDashboard(),
          ),
        );
        return;
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  void dispose() {
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  bool passshow = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Transform(
                  transform: Matrix4.translationValues(
                      animation.value * width, 0.0, 0.0),
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Hello',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(30.0, 35.0, 0, 0),
                            child: Text(
                              'There',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(135.0, 0.0, 0, 30),
                          child: Container(
                            child: Text(
                              '.',
                              style: TextStyle(
                                  color: Colors.green[400],
                                  fontSize: 80.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10, 30, 10),
                child: Transform(
                  transform:
                      Matrix4.translationValues(LeftCurve.value * width, 0, 0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Form(
                            key: _formField,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'EMAIL',
                                    contentPadding: EdgeInsets.all(5),
                                    labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.grey),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter an email';
                                    }
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  controller: passwordController,
                                  obscuringCharacter: '*',
                                  decoration: InputDecoration(
                                      suffix: passshow == false
                                          ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  passshow = true;
                                                });
                                              },
                                              icon: Icon(Icons.lock_open),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  passshow = false;
                                                });
                                              },
                                              icon: Icon(Icons.lock),
                                            ),
                                      labelText: 'PASSWORD',
                                      contentPadding: EdgeInsets.all(5),
                                      labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.green))),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    if (value!.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  obscureText: passshow == false ? true : false,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 10, 30, 10),
                child: Transform(
                  transform: Matrix4.translationValues(
                      delayedAnimation.value * width, 0, 0),
                  child: Container(
                    alignment: Alignment(1.0, 0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 20.0),
                      child: Bouncing(
                        onPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ForgotPassword(),
                              ));
                        },
                        key: _formkey,
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
                child: Transform(
                  transform: Matrix4.translationValues(
                      muchDelayedAnimation.value * width, 0, 0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Bouncing(
                          onPress: () {},
                          child: MaterialButton(
                            onPressed: () {
                              if (_formField.currentState!.validate()) {
                                login();
                              }else{
                                print("Fail");
                              }
                            },
                            elevation: 0.0,
                            minWidth: MediaQuery.of(context).size.width,
                            color: Colors.green,
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Bouncing(
                          onPress: () {},
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RequestLogin(),
                                  ));
                            },
                            elevation: 0.5,
                            minWidth: MediaQuery.of(context).size.width,
                            color: Colors.grey[300],
                            child: ListTile(
                              leading: Icon(
                                Icons.fingerprint,
                                color: Colors.black,
                              ),
                              title: Text('Request Login ID'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
