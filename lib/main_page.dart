import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/chat_page.dart';
import 'pages/add_post_page.dart';
import 'pages/notification_page.dart';
import 'pages/profil.dart';
import 'pages/post_detail_page.dart';

class MainPage extends StatefulWidget {
   const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  Map<String, dynamic>? _selectedPost;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedPost = null;
    });
  }

  void _openPostDetail(Map<String, dynamic> post) {
    setState(() {
      _selectedPost = post;
    });
  }

  void _closePostDetail() {
    setState(() {
      _selectedPost = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomePage(onOpenDetail: _openPostDetail),
       ChatPage(),
       AddPostPage(),
       NotificationPage(),
       ProfilPage(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          if (_selectedPost != null && _selectedIndex == 0)
            PostDetailPage(
              post: _selectedPost!,
              onBack: _closePostDetail,
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Tambah'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
