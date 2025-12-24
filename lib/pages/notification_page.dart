import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifikasi")),
      body: ListView(
        children: [
          ListTile(title: Text("Rina menyukai postinganmu")),
          ListTile(title: Text("Doni mengomentari postinganmu")),
        ],
      ),
    );
  }
}
