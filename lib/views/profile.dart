import 'package:flutter/material.dart';
import 'my_profile.dart';  // Import halaman MyProfilePage

class ProfilePage extends StatelessWidget {
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
                  MaterialPageRoute(builder: (context) => MyProfilePage()),
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
                        "Lihat Profile",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16), // Geser ke bawah
            // Tambahkan konten profil di sini

            // Tambahkan daftar "Yang Baru", "Riwayat Mendengarkan", dan "Pengaturan dan Privasi"
            ListTile(
              leading: Icon(Icons.flash_on), // Icon flash atau petir atau trending
              title: Text("Yang Baru"),
              onTap: () {
                // Tambahkan aksi yang sesuai ketika "Yang Baru" diklik
              },
            ),
            ListTile(
              leading: Icon(Icons.access_time), // Icon waktu/riwayat
              title: Text("Riwayat Mendengarkan"),
              onTap: () {
                // Tambahkan aksi yang sesuai ketika "Riwayat Mendengarkan" diklik
              },
            ),
            ListTile(
              leading: Icon(Icons.settings), // Icon setting
              title: Text("Pengaturan dan Privasi"),
              onTap: () {
                // Tambahkan aksi yang sesuai ketika "Pengaturan dan Privasi" diklik
              },
            ),
          ],
        ),
      ),
    );
  }
}
