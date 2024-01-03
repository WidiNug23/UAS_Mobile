import 'package:flutter/material.dart';
import 'package:spotify_mobile/database_helper.dart';
import 'package:spotify_mobile/views/my_playlist.dart';
import 'tambah_playlist.dart';
import 'profile.dart'; // Import file profile.dart

class PlaylistView extends StatefulWidget {
  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  late List<Map<String, dynamic>> playlistData;

  @override
  void initState() {
    super.initState();
    refreshPlaylist();
  }

  void refreshPlaylist() async {
    try {
      List<Map<String, dynamic>> playlists = await DatabaseHelper().getPlaylists();

      print("Refreshed Playlist: $playlists"); // Debug statement

      setState(() {
        playlistData = playlists;
      });
    } catch (e) {
      print("Error refreshing playlist: $e");
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: GestureDetector(
          onTap: () {
            // Navigasi ke halaman profile.dart saat "W" diklik
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  "W",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Koleksi Kamu",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action when search icon is clicked
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Action when plus icon is clicked
              showBottomSheet(context);
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: playlistData.length,
          itemBuilder: (context, index) {
            String playlistName = playlistData[index]['name'];
            String coverPath = playlistData[index]['cover_path'];

            return ListTile(
              title: Text(
                playlistName,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Subjudul Playlist", // Ganti dengan data subjudul yang sesuai
                style: TextStyle(color: Colors.grey),
              ),
              leading: CircleAvatar(
                backgroundImage: AssetImage(coverPath), // Assuming coverPath is the image asset path
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPlaylistPage(
                      playlistId: playlistData[index]['id'], // Assuming 'id' is the column name for the playlist id in your database
                      playlistName: playlistName,
                      coverPath: coverPath,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.music_note, color: Colors.white),
                title: Text(
                  "Playlist",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TambahPlaylistPage(
                        onPlaylistCreated: (newPlaylistName) {
                          refreshPlaylist();
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.blur_on, color: Colors.white),
                title: Text(
                  "Blend",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
