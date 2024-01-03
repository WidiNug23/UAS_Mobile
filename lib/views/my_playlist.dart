import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:spotify_mobile/database_helper.dart';

class MyPlaylistPage extends StatefulWidget {
  final int playlistId;
  final String playlistName;
  final String coverPath;

  MyPlaylistPage({
    required this.playlistId,
    required this.playlistName,
    required this.coverPath,
  });

  @override
  _MyPlaylistPageState createState() => _MyPlaylistPageState();
}

class _MyPlaylistPageState extends State<MyPlaylistPage> {
  File? _image;
  TextEditingController _playlistNameController = TextEditingController();
  String? _tempImagePath; // Temporary path for the selected image
  bool _pathError = false; // Flag to indicate path error
  double _imageSize = 0.0;
  final double _minImageSize = 0.0;
  final double _maxImageSize = 100.0; // Sesuaikan sesuai kebutuhan

  @override
  void initState() {
    super.initState();
    _playlistNameController.text = widget.playlistName;
    // Load existing image path when the page is initialized
    _tempImagePath = widget.coverPath.isNotEmpty ? widget.coverPath : null;
    _checkPathError();
  }

  Future _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _tempImagePath = pickedFile.path;
      }
      _checkPathError();
      saveChanges();
    });
  }

  void saveChanges() async {
    try {
      String? newCoverPath = _tempImagePath != null ? _tempImagePath : "";
      await DatabaseHelper().updatePlaylist(
        widget.playlistId,
        _playlistNameController.text,
        newCoverPath,
      );

      print("Auto-Saving Playlist Name: ${_playlistNameController.text}");
    } catch (e) {
      print('Error saving changes: $e');
    }
  }

  void _checkPathError() {
    // Check if the file path exists
    setState(() {
      _pathError = _tempImagePath != null && !File(_tempImagePath!).existsSync();
    });
  }

  void _editPlaylistName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Playlist Name"),
          content: TextField(
            controller: _playlistNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Playlist Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                saveChanges();
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _confirmDeletePlaylist() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus Playlist"),
          content: Text("Anda yakin ingin menghapus playlist ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  void _deletePlaylist() async {
    bool shouldDelete = await _confirmDeletePlaylist();
    if (shouldDelete) {
      await DatabaseHelper().deletePlaylist(widget.playlistId);
      Navigator.pop(context); // Kembali ke halaman playlist_view.dart setelah menghapus playlist
    }
  }

  void _showOptionsPopup() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildOptionItem(Icons.music_note, 'Dengarkan musik bebas iklan'),
              _buildOptionItem(Icons.edit, 'Edit playlist'),
              _buildOptionItem(Icons.delete, 'Hapus Playlist'),
              _buildOptionItem(Icons.share, 'Bagikan'),
              _buildOptionItem(Icons.person_add, 'Undang kolaborator'),
              _buildOptionItem(Icons.delete_forever, 'Hapus dari profil'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionItem(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () async {
        // Tambahkan logika untuk setiap opsi di sini
        Navigator.pop(context); // Tutup popup setelah opsi diklik

        if (label == 'Hapus Playlist') {
          _deletePlaylist();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            double scrollDistance = scrollNotification.scrollDelta ?? 0.0;

            setState(() {
              if (scrollDistance > 0) {
                // Scroll ke bawah: Gambar membesar
                _imageSize += scrollDistance / 5;
              } else {
                // Scroll ke atas: Gambar mengecil
                _imageSize += scrollDistance / 5;
              }

              _imageSize = _imageSize.clamp(_minImageSize, _maxImageSize);
            });

            return true;
          }
          return false;
        },
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                _getImage();
              },
              child: Container(
                height: 200 + _imageSize,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.topCenter,
                color: const Color.fromARGB(255, 156, 153, 154),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.5),
                              offset: Offset(0, 20),
                              blurRadius: 32,
                              spreadRadius: 16,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: _tempImagePath == null || _pathError
                              ? Center(
                                  child: Icon(Icons.album, color: Colors.white, size: 80.0, semanticLabel: 'Cassette Tape'),
                                )
                              : Image.file(
                                  File(_tempImagePath!),
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  _editPlaylistName();
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _playlistNameController.text,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Baris pertama (Lingkaran "W" dan Teks "Widi")
            Row(
              children: [
                // Lingkaran yang berisi huruf "W"
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Text(
                    'W',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                // Teks "Widi"
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Widi'),
                ),
              ],
            ),
            SizedBox(height: 8), // Spasi antara baris pertama dan kedua
            // Baris kedua (Ikon-ikon: Download, Profile, Share, Option)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    // Add download functionality
                  },
                  icon: Icon(Icons.download),
                ),
                SizedBox(width: 8), // Jarak antar ikon
                IconButton(
                  onPressed: () {
                    // Add profile functionality
                  },
                  icon: Icon(Icons.person),
                ),
                SizedBox(width: 8), // Jarak antar ikon
                IconButton(
                  onPressed: () {
                    // Add share functionality
                  },
                  icon: Icon(Icons.share),
                ),
                SizedBox(width: 8), // Jarak antar ikon
                IconButton(
                  onPressed: () {
                    _showOptionsPopup(); // Panggil fungsi untuk menampilkan popup opsi
                  },
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
