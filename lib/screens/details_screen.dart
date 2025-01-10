import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailsScreen extends StatelessWidget {
  final Map movie;

  DetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie['name'] ?? 'No Title')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWithPlaceholder(movie['image']?['original'] ?? ''),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                movie['summary']?.replaceAll(RegExp('<[^>]*>'), '') ??
                    'No Summary',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithPlaceholder(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.0), // Apply border radius
        child: imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null)
                    return child; // Image is fully loaded
                  return _shimmerPlaceholder(); // Show shimmer while loading
                },
                errorBuilder: (context, error, stackTrace) {
                  return _shimmerPlaceholder(); // Show shimmer if image fails to load
                },
                fit: BoxFit.cover, // Ensure the image fits the outline
                width: double.infinity,
                // height: 250.0, // Match height with shimmer
              )
            : _shimmerPlaceholder(), // Show shimmer if no image URL
      ),
    );
  }

  Widget _shimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 20, 20, 20)!,
      highlightColor: const Color.fromARGB(255, 49, 48, 48)!,
      period: Duration(milliseconds: 1500), // Control speed of animation
      direction: ShimmerDirection.ltr, // Animation direction
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            Colors.grey[300]!,
            Colors.grey[100]!,
            Colors.grey[300]!,
          ],
          stops: [0.3, 0.5, 0.7], // Adjust the thickness of the highlight
          begin: Alignment(-1.0, 0.0),
          end: Alignment(1.0, 0.0),
        ).createShader(bounds),
        child: Container(
          width: double.infinity,
          height: 250.0, // Placeholder height
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        blendMode: BlendMode.srcATop,
      ),
    );
  }
}
