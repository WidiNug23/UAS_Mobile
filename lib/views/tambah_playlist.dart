// tambah_playlist.dart
import 'package:flutter/material.dart';
import 'package:spotify_mobile/database_helper.dart';
import 'my_playlist.dart';
import 'playlist_view.dart';

class TambahPlaylistPage extends StatefulWidget {
  final String playlistName;
  final Function(String)? onPlaylistCreated;

  TambahPlaylistPage({this.playlistName = "", this.onPlaylistCreated});

  @override
  _TambahPlaylistPageState createState() => _TambahPlaylistPageState();
}

class _TambahPlaylistPageState extends State<TambahPlaylistPage> {
  final TextEditingController _playlistNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Playlist"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Beri nama playlist-mu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _playlistNameController,
              decoration: InputDecoration(
                hintText: "Nama Playlist",
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Batal"),
                ),
               ElevatedButton(
  onPressed: () async {
    String playlistName = _playlistNameController.text.trim();
    if (playlistName.isNotEmpty) {
      await DatabaseHelper().insertPlaylist(playlistName, "path_to_cover_image");

      print("Playlist Inserted"); // Debug statement

      bool hasSongs = checkIfPlaylistHasSongs(); // Replace this with your logic

      if (hasSongs) {
        widget.onPlaylistCreated?.call(playlistName);

        // Navigasi ke MyPlaylistPage setelah playlist dibuat
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyPlaylistPage(
              playlistId: 0, // Ganti dengan ID playlist yang sesuai
              playlistName: playlistName,
              coverPath: "path_to_cover_image",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Playlist has no songs."),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nama Playlist tidak boleh kosong."),
        ),
      );
    }
  },
  child: Text("Buat"),
),

              ],
            ),
          ],
        ),
      ),
    );
  }

  bool checkIfPlaylistHasSongs() {
    // Implement your logic to check if the playlist has songs
    // For example, check if a list of songs is not empty
    return true;
  }
}
