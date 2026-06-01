import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const UserAvatar({Key? key, this.imageUrl, this.radius = 24}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: imageUrl!.startsWith('http')
            ? NetworkImage(imageUrl!)
            : AssetImage(imageUrl!) as ImageProvider,
        backgroundColor: Colors.grey[200],
      );
    } else {
      return CircleAvatar(
        radius: radius,
        child: Icon(Icons.person, size: radius),
        backgroundColor: Colors.grey[200],
      );
    }
  }
} 