import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/userModel.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Assuming Font Awesome



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  void Loading() {
    setState(() {
      load = true; // Show loading indicator
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        load = false; // Hide loading indicator
      });
    });
  }



  Future<void> login() async {
    try {
      Loading();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );
      await saveUserToFirestore();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }


  Future<void> saveUserToFirestore() async {
     final user = FirebaseAuth.instance.currentUser;
     final Users users = Users(
         userId: DateTime.now().millisecondsSinceEpoch.toString(),
         email: emailController.text,
         phoneNo: passwordController.text
     );
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

  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
                Text("Sign in now",textAlign: TextAlign.center,style: TextStyle(color: Colors.deepPurple,fontSize:30.0,fontWeight: FontWeight.bold),),
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    const Icon(Icons.lock, size: 50, color: Colors.white),
                    SizedBox(height: 20),
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
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
                        ),
                        child: Text('Forgot Password?', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(150, 45)
                      ),
                      child: load? CircularProgressIndicator(
                      ):Text("Login"),
                      onPressed: ()=> login(),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      ),
                      child: Text('Don\'t have an account? Sign up', style: TextStyle(color: Colors.white)),
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
