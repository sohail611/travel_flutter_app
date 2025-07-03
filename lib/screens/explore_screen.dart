import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/trip_detail_screen.dart';
import 'package:provider/provider.dart';

import '../data/models/userModel.dart';
import 'favorites_provider.dart';

class ExploreScreen extends StatefulWidget {

   ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<Map<String, dynamic>> packages = [
    {
      "title": "Santorini Island",
      "date": "16 July - 28 July",
      "rating": 4.8,
      "joined": 24,
      "price": 820,
      "image": "assets/images/Bukita.jpg",
      'isFavorite': false,
    },
    {
      "title": "Bukita Rayandro",
      "date": "20 Sep - 29 Sep",
      "rating": 4.3,
      "joined": 24,
      "price": 720,
      'isFavorite': false,
      "image": "assets/images/Cluster.jpg"
    },
    {
      "title": "Cluster Omega",
      "date": "14 Nov - 22 Nov",
      "rating": 4.9,
      "joined": 26,
      "price": 942,
      'isFavorite': false,
      "image": "assets/images/pais.jpg"
    },
    {
      "title": "Shajek Bandarban",
      "date": "12 Dec - 18 Dec",
      "rating": 4.5,
      "joined": 27,
      "price": 860,
      'isFavorite': false,
      "image": "assets/images/Shajek.jpg"
    },
    {
      "title": "Santorini Island",
      "date": "16 July - 28 July",
      "rating": 4.8,
      "joined": 24,
      "price": 820,
      'isFavorite': false,
      "image": "assets/images/Bukita.jpg"
    },
    {
      "title": "Bukita Rayandro",
      "date": "20 Sep - 29 Sep",
      "rating": 4.3,
      "joined": 24,
      "price": 720,
      'isFavorite': false,
      "image": "assets/images/Cluster.jpg"
    },
    {
      "title": "Cluster Omega",
      "date": "14 Nov - 22 Nov",
      "rating": 4.9,
      "joined": 26,
      "price": 942,
      'isFavorite': false,
      "image": "assets/images/pais.jpg"
    },
    {
      "title": "Shajek Bandarban",
      "date": "12 Dec - 18 Dec",
      "rating": 4.5,
      "joined": 27,
      "price": 860,
      'isFavorite': false,
      "image": "assets/images/Shajek.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(title:Text("Popular Place",style: TextStyle(fontWeight: FontWeight.bold)),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: packages.length,
          itemBuilder: (context, index) {
            final item = packages[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 550), // 👈 slower animation
                    pageBuilder: (context, animation, secondaryAnimation) => TripDetailScreen(trip: item),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
             child: Container(
              margin: EdgeInsets.only(bottom: 26),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: item['image'],
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child:  Image.asset(
                      item["image"],
                      height: 140,
                      width: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["title"],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item["date"],
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(item["rating"].toString(),
                                style: TextStyle(fontSize: 12)),
                            SizedBox(width: 8),
                            Text("${item["joined"]} Joined",
                                style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  ),
                        SizedBox(width: 8),
                  Column(
                    children: [
                      Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                         "\$${item["price"]}",
                        style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      SizedBox(height: 70),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
                          // onTap: () {
                          //   setState(() {
                          //     item['isFavorite'] = !item['isFavorite'];
                          //   });
                          // },
                          child: IconButton(
                            icon: Icon(
                              Provider.of<FavoritesProvider>(context).isFavorite(item["title"])
                                  ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                          ),
                            onPressed: (){
                              // setState(() {
                              //   item['isFavorite'] = !item['isFavorite'];
                              // });
                                Provider.of<FavoritesProvider>(context, listen: false).toggleFavorite(
                                  FavoriteItem(
                                    title: item["title"],
                                    imageUrl: item["image"],
                                    date: item["date"],
                                  ),
                                );
                            },
                        ),
                      ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            );
          },
        ),
      ),
    );
  }
}
