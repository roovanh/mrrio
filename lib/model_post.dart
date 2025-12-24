import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String description;
  final String imageUrl;
  final Timestamp createdAt;

  Post({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'timestamp': createdAt,
    };
  }
  
  Post.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        description = doc.data()?['description'],
        imageUrl = doc.data()?['imageUrl'],
        createdAt = doc.data()?['createdAt'];

  



}