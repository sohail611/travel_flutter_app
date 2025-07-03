import 'dart:convert';
import 'package:flutter_arfa_task_5_sohail_anwar/data/models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  late SharedPreferences pref;

  @override
  void initState() {
    initPreferences();
    super.initState();
  }

  Future<void> signup() async {
    final Users users = Users(
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        email: emailController.text,
        phoneNo: passwordController.text
    );

    String jsonString = jsonEncode(users);
    pref.setString("userData", jsonString);
    pref.setBool("isLogin", true);

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await saveUserToFirestore();
      print("register user true🚕🚕🚕🚕");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${e.toString()}')),
      );
    }
  }
  void initPreferences() async {
    pref = await SharedPreferences.getInstance();
  }

  Future<void> saveUserToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Only write if the doc doesn't exist
      final doc = await userRef.get();
      final fcmToken = await FirebaseMessaging.instance.getToken();

      if (!doc.exists) {
        await userRef.set({
          'uid': user.uid,
          'name': user.displayName ?? user.email.toString(),
          'email': user.email,
          'photoUrl': user.photoURL ?? '',
          'fcmToken': fcmToken,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Sign up now ",textAlign: TextAlign.center,style: TextStyle(color: Colors.purpleAccent,fontSize:30.0,fontWeight: FontWeight.bold),),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Icon(Icons.person_add, size: 50, color: Colors.white),
                    const SizedBox(height: 20,),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => isObscure = !isObscure);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: signup,
                      child: Text('Sign Up'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
                      child: Text('Already have an account? Login', style: TextStyle(color: Colors.white)
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          iconSize: 70,
                            icon: const Icon(FontAwesomeIcons.whatsapp,color: Colors.green,), onPressed: () {  },
                        ),
                        IconButton(
                          iconSize: 70,
                          icon: const Icon(FontAwesomeIcons.instagram,color:Colors.pinkAccent,), onPressed: () {  },
                        ),
                        IconButton(
                          iconSize: 70,
                          icon: const Icon(Icons.facebook,color: Colors.indigo,), onPressed: () {  },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
