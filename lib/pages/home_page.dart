import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model_post.dart';

class HomePage extends StatelessWidget {
  final Function(Map<String, dynamic>) onOpenDetail;

  const HomePage({super.key, required this.onOpenDetail});

  Stream<List<Post>> readPosts() {
    return FirebaseFirestore.instance
        .collection("posts")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromDocSnapshot(doc)).toList());
  }

  String formatTime(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return DateFormat('dd MMM yyyy • HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.montserrat(
              textStyle:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            children:  [
              TextSpan(text: 'Campus', style: TextStyle(color: Colors.blue)),
              TextSpan(text: 'Collab', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),

      body: StreamBuilder<List<Post>>(
        stream: readPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return  Center(child: Text("Belum ada postingan"));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return Column(
                children: [
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.all(0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Text("U"),
                          ),
                          title: Text(
                            "User",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            formatTime(post.createdAt),
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.more_horiz),
                            onPressed: () {},
                          ),
                        ),

                        if (post.imageUrl.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 60),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                post.imageUrl,
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 250,
                                  height: 250,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.broken_image, size: 40),
                                ),
                              ),
                            ),
                          ),

                         SizedBox(height: 12),

                        Padding(
                          padding:  EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 12,
                          ),
                          child: Text(
                            post.description,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),

                         SizedBox(height: 12),
                      ],
                    ),
                  ),
                   Divider(height: 0, thickness: 1, color: Colors.grey),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
