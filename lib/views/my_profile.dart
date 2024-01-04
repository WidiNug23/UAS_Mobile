import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  TextEditingController _nameController = TextEditingController();
  File? _image;

  static String _displayName = ''; // Variabel statis untuk menyimpan display name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                _showEditProfileDialog();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 16),
                  Align(
                    alignment: Alignment.bottomCenter, // Menyesuaikan posisi vertikal
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 60,
                        backgroundImage: _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? Text(
                                _displayName.isNotEmpty
                                    ? _displayName[0].toUpperCase()
                                    : "W",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 48.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.bottomLeft, // Menyesuaikan posisi vertikal
                        child: Text(
                          _displayName.isNotEmpty ? _displayName : "Widi",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Align(
                        alignment: Alignment.bottomLeft, // Menyesuaikan posisi vertikal
                        child: Text(
                          "0 pengikut - 0 mengikuti",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
             SizedBox(height: 16),
           Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    // Tambahkan aksi yang sesuai ketika tombol "Edit" diklik
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Text("Edit"),
                ),
                SizedBox(width: 8.0), // Memberikan jarak antara tombol "Edit" dan ikon opsi
                IconButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {
                    // Tambahkan aksi yang sesuai ketika ikon opsi diklik
                  },
                ),
              ],
            )
          ],
        ),
      ),

      
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _saveChangesAndPop();
          },
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    TextEditingController tempNameController = TextEditingController();
    tempNameController.text = _displayName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profil"),
          content: Column(
            children: [
              TextField(
                controller: tempNameController,
                decoration: InputDecoration(labelText: "Nama"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _getImageFromGallery();
                  Navigator.pop(context, tempNameController.text);
                },
                child: Text("Ganti Foto Profil"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                _displayName = tempNameController.text;
                Navigator.pop(context, tempNameController.text);
                setState(() {});
              },
              child: Text("Simpan"),
            ),
          ],
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          _nameController.text = result;
        });
      }
    });
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _saveChangesAndPop() {
    // Save changes to your database or wherever you need to persist the data
    Navigator.pop(context);
  }
}
