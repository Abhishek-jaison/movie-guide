import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];

  void searchMovies(String query) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: 'Search for a movie...'),
          onSubmitted: searchMovies,
        ),
      ),
      body: searchResults.isEmpty
          ? Center(child: Text('No results found'))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final movie = searchResults[index]['show'];
                return ListTile(
                  leading: Image.network(
                    movie['image']?['medium'] ?? '',
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported),
                  ),
                  title: Text(movie['name'] ?? 'No Title'),
                  subtitle: Text(
                    movie['summary'] != null
                        ? movie['summary']
                                .replaceAll(
                                    RegExp('<[^>]*>'), '') // Remove HTML tags
                                .split(' ')
                                .take(20)
                                .join(' ') +
                            '...' // Show only the first 20 words
                        : 'No Summary',
                  ),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: movie,
                  ),
                );
              },
            ),
    );
  }
}
