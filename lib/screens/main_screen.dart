import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/FavoriteScreen.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/chat_users_screen.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/expence/exp.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/expence/video.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/explore_screen.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/hive/Hive.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/home_screen.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/profile_screen.dart';


class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<StatefulWidget> createState() => _NavbarState();
}

class _NavbarState extends State<NavBar> {
  int _selectedIndex = 0;


  final List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    ChatUsersScreen(), //Center(child: Text(...))
    FavoriteScreen(),
    ProfileScreen(),
    ReceiptScreen(),
    TodoList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
          child:
         AppBar(
         backgroundColor: Colors.white10,
         leading:Image.asset(
          "assets/images/bell.png",
          fit: BoxFit.contain,
          height: 20,
        ) ,
        centerTitle: true,
        elevation: 2,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset("assets/images/original-c9de8d5dcb218367bd6af5352d4afbed.png",
                  fit: BoxFit.contain,
                  height: 100,
                ),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings,color: Colors.orange,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Center(child: Text("Settings\nComming Soon"));
                  },
                ),
              );
            },
            color: Colors.white,
          )
        ],
      ),
      ),
      body: _screens[_selectedIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        width: size.width,
        height: 80,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(size.width, 80),
              painter: BNBCustomePainter(),
            ),
            Center(
              heightFactor: 0.6,
              child: FloatingActionButton(
                onPressed: () {
                  _onItemTapped(2);
                },
                backgroundColor: Colors.orange,
                child: Icon(Icons.message_outlined),
                elevation: 0.1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.home,
                      color: _selectedIndex == 0 ? Colors.orange : Colors.grey),
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  icon: Icon(Icons.explore,
                      color: _selectedIndex == 1 ? Colors.orange : Colors.grey),
                  onPressed: () => _onItemTapped(1),
                ),
                IconButton(
                  icon: Icon(Icons.receipt,
                      color: _selectedIndex == 6 ? Colors.orange : Colors.grey),
                  onPressed: () => _onItemTapped(6),
                ),

                SizedBox(width: size.width * 0.20),

                IconButton(
                  icon: Icon(Icons.bookmark_add,
                      color: _selectedIndex == 3 ? Colors.orange : Colors.grey),
                  onPressed: () => _onItemTapped(3),
                ),
                IconButton(
                  icon: Icon(Icons.account_circle,
                      color: _selectedIndex == 4 ? Colors.orange : Colors.grey),
                  onPressed: () => _onItemTapped(4),
                ),
                IconButton(
                  icon: Icon(Icons.receipt_long,
                      color: _selectedIndex == 5 ? Colors.orange : Colors.grey),
                  onPressed: () => _onItemTapped(5),
                ),
              ],
            ),
          ],
        ),
      ),


    );
  }
}

class BNBCustomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()
      ..moveTo(0, 20);
    path.quadraticBezierTo(size.width * .20, 0, size.width * .35, 0);
    path.quadraticBezierTo(size.width * .40, 0, size.width * .40, 20);
    path.arcToPoint(Offset(size.width * .60, 20),
        radius: Radius.circular(10.0), clockwise: false);

    path.quadraticBezierTo(size.width * .60, 0, size.width * .65, 0);
    path.quadraticBezierTo(size.width * .80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black, 5, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
