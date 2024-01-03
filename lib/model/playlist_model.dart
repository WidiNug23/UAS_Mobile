import 'dart:html';

class PlaylistModel {
  final int id; // Add an id field
  final String name;
  final Blob coverPath;

  PlaylistModel({required this.id, required this.name, required this.coverPath});
}
