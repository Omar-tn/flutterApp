import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class itemWidget extends StatelessWidget {
  String image;

  itemWidget({required this.image});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Stack(children: [Image.asset(image)]));
  }
}

class ProfileCard extends StatelessWidget {
  final String title;
  final String subtitle; // Optional subtitle
  final IconData icon; // Icon to display
  final VoidCallback? onTap; // Action when tapped

  const ProfileCard({
    Key? key,
    required this.title,
    this.subtitle = "",
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.blue), // Icon styling
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

