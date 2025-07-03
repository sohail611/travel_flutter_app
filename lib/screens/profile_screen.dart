import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/FavoriteScreen.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/login_screen.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/signup_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white10,
        elevation: 0,
      ),
      body:
       user == null
        ? Center(child: Text("No user signed in")):
      Column(
        children: [
          SizedBox(height: 30),
          CircleAvatar(
            radius: 50,
            backgroundImage: user.photoURL != null
                ? NetworkImage(user.photoURL!)
                : AssetImage('assets/images/people.jpg')
            as ImageProvider,
          ),
          SizedBox(height: 16),
          Text(
            user.displayName ?? 'Anonymous',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            user.email ?? 'No email',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 30),
          Divider(thickness: 1),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text("Favorites"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteScreen()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to settings
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
