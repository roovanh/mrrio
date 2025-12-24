import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;
  final VoidCallback onBack;

  const PostDetailPage({super.key, required this.post, required this.onBack});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late List<dynamic> comments;
  late bool isLiked;
  late int likes;

  @override
  void initState() {
    super.initState();
    comments = List.from(widget.post['comments'] ?? []);
    isLiked = widget.post['isLiked'] ?? false;
    likes = widget.post['likes'] ?? 0;
  }

  String formatTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('dd MMM yyyy • HH:mm').format(dateTime);
  }

  void _showCommentSheet(BuildContext context) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tulis Komentar",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "Tulis komentar kamu...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  final newComment = {
                    "user": "Kamu",
                    "text": commentController.text.trim(),
                  };
                  if (newComment["text"]!.isNotEmpty) {
                    setState(() {
                      comments.add(newComment);
                    });
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.send),
                label: Text("Kirim"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final username = post['username'] ?? 'Anonim';
    final nim = post['nim'] ?? '-';
    final content = post['content'] ?? '';
    final imageUrl = post['imageUrl'];
    final time = post['time'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            children: [
              TextSpan(text: 'Campus', style: TextStyle(color: Colors.blue)),
              TextSpan(text: 'Collab', style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(value: 'lapor', child: Text('Laporkan')),
                ],
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(username[0].toUpperCase()),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "#$nim • ${formatTime(time)}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12),

          if (imageUrl != null && imageUrl.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0),
              child: SizedBox(
                width: 250,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(Icons.broken_image, size: 40),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),

          SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(content, style: TextStyle(fontSize: 15)),
          ),

          SizedBox(height: 22),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 26,
                  ),
                ),
                SizedBox(width: 20),

                GestureDetector(
                  onTap: () => _showCommentSheet(context),
                  child: Icon(Icons.mode_comment_outlined, size: 26),
                ),
                SizedBox(width: 20),

                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.share_outlined, size: 26),
                ),
                SizedBox(width: 20),

                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.bookmark_border, size: 26),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 25, bottom: 8, top: 4),
            child: Text(
              "$likes suka • ${comments.length} komentar",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),

          const Divider(height: 30),

          Text(
            "Komentar",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),

          if (comments.isEmpty)
            Text("Belum ada komentar.")
          else
            ...comments.map(
              (c) => ListTile(
                leading: Icon(Icons.person),
                title: Text(c['user']),
                subtitle: Text(c['text']),
              ),
            ),
        ],
      ),
    );
  }
}
