import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Alignment, AssetImage, Axis, Border, BorderRadius, BorderSide, BoxDecoration, BoxFit, BoxShadow, BuildContext, CircleAvatar, Colors, Column, Container, CrossAxisAlignment, DecorationImage, EdgeInsets, FontWeight, Icon, IconButton, Icons, InputDecoration, LinearGradient, ListView, MaterialPageRoute, Offset, OutlineInputBorder, Padding, Positioned, RichText, Row, SafeArea, Scaffold, SizedBox, Stack, StatelessWidget, Text, TextField, TextSpan, TextStyle, Widget;
import 'package:flutter_arfa_task_5_sohail_anwar/screens/trip_detail_screen.dart';
import 'package:provider/provider.dart';

import '../data/models/userModel.dart';
import 'favorites_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> destinations = [
    {
      "title": "Paris France",
      "date": "18 July - 28 July",
      "rating": 5.0,
      "joined": 31,
      "price": 920,
      "image": "assets/images/pais.jpg",
      "name": "Paris",
      "location": "France",
      'isFavorite': false,
    },
    {
      "title": "Indonesia Bali",
      "date": "19 July - 28 July",
      "rating": 3.8,
      "joined": 40,
      "price": 810,
      "image": "assets/images/bali.jpg",
      "name": "Bali",
      "location": "Indonesia",
      'isFavorite': false,
    },
    {
      "title": "Tokyo Japan",
      "date": "10 July - 28 July",
      "rating": 4.5,
      "joined": 30,
      "price": 820,
      "image": "assets/images/tokyo.jpg",
      "name": "Tokyo",
      "location": "Japan",
      'isFavorite': false,
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                "Hi, 👋",
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
              RichText(
                 text: TextSpan(
                  style: TextStyle(
                      fontSize:30),
                   children: [
                     TextSpan(
                       text: "Explore the\n",
                       style: TextStyle(color: Colors.black87),
                     ),
                     TextSpan(
                       text: "Beaautiul ",
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: Colors.black87,
                       ),
                     ),
                     TextSpan(
                       text: "world!",
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         color: Colors.orange,
                       ),
                     ),
                   ],
                 ),
              ),
              Positioned(
                bottom: 0,
                left: 185,
                child: Container(
                  width: 80,
                    height: 8,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.orange,
                        width: 4,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search destination",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Best Destinations",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 350, // ⬆️ Increase card height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    final place = destinations[index];
                    return GestureDetector(
                        onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TripDetailScreen(trip: place),
                        ),
                      );
                    },
                      child: Container(
                      width: 350,
                      margin: EdgeInsets.only(right: 16),
                      child: Stack(
                        children: [
                          Container(
                            height: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(place["image"]!),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      ),
                       Container(
                        height: 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),

                      // Favorite icon top-right
                      Positioned(
                        top: 12,
                        right: 12,

                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              place['isFavorite'] = !place['isFavorite'];
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.8),
                            child: IconButton(
                              icon: Icon(
                                Provider.of<FavoritesProvider>(context).isFavorite(place["title"])
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Provider.of<FavoritesProvider>(context, listen: false).toggleFavorite(
                                  FavoriteItem(
                                    title: place["title"],
                                    imageUrl: place["image"],
                                    date: place["date"],
                                  ),
                                );
                              },
                            ),

                          ),
                        ),
                      ),

                      // Destination info bottom-left
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              place["name"]!,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              place["location"]!,
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(height: 8),

                            // 👥 Avatars of travelers
                            Row(
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundImage: AssetImage('assets/images/people.jpg'),
                                    ),
                                  ),
                                Text("+20", style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                      ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
