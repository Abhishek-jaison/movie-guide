import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  fetchMovies() async {
    final response =
        await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/search'),
          child: Text('Search Movies'),
        ),
      ),
      body: movies.isEmpty
          ? Center(child: Lottie.asset('lib/assets/loading.json'))
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index]['show'];
                return ListTile(
                  leading: Image.network(
                    movie['image']?['medium'] ?? '',
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      size: 40,
                    ),
                  ),
                  title: Text(
                    movie['name'] ?? 'No Title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie['summary'] != null
                            ? movie['summary']
                                    .replaceAll(RegExp('<[^>]*>'),
                                        '') // Remove HTML tags
                                    .split(' ')
                                    .take(20)
                                    .join(' ') +
                                '...' // Show only the first 20 words
                            : 'No Summary',
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Rating: ${movie['rating']?['average'] ?? 'N/A'}', // Display rating or 'N/A'
                        style: TextStyle(),
                      ),
                    ],
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: movie,
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/search');
          }
        },
      ),
    );
  }
}
