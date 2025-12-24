import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tugas_oo/main_page.dart';
import '../model_post.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  List<Post> details = [];

  // Baca data dari Firestore
  Future readData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var data = await db.collection("posts").get();

    setState(() {
      details = data.docs.map((doc) => Post.fromDocSnapshot(doc)).toList();
    });
  }

  // Tambah data dengan input user
  Future addData(String description, String imageUrl) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("posts").add({
      'createdAt': Timestamp.now(),
      'description': description,
      'imageUrl': imageUrl,
    });
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController postController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Tambah Postingan")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: "Masukkan URL Gambar",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.image),
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: postController,
              decoration: InputDecoration(
                labelText: "Tulis sesuatu...",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),

            SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final description = postController.text.trim();
                  final imageUrl = imageUrlController.text.trim();

                  if (description.isEmpty || imageUrl.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Deskripsi dan URL gambar wajib diisi!"),
                      ),
                    );
                    return;
                  }

                  await addData(description, imageUrl);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Postingan berhasil dikirim!")),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                  );
                },
                icon: Icon(Icons.send),
                label: Text("Kirim"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
