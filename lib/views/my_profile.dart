import 'package:flutter/material.dart';
import 'package:spotify_mobile/views/profile.dart';
import 'my_profile.dart';  // Import halaman MyProfilePage

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50), // Tambahkan jarak vertikal di sini
            GestureDetector(
              onTap: () {
                // Navigasi ke halaman MyProfilePage saat "Widi" diklik
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 16), // Tambahkan jarak horizontal di sini
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, right: 8.0), // Tambahkan jarak di sekitar lingkaran "W"
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Text(
                        "W",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      radius: 21,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Widi",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Profil Anda",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),  // Geser ke bawah
            // Tambahkan konten profil di sini
          ],
        ),
      ),
    );
  }
}
