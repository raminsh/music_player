import 'package:music_player/models/json_model.dart';

class Song extends JsonModel<Song>{
  final String artistName;
  final String collectionName;
  final String trackName;
  final String artworkUrl;
  final String previewUrl;

  Song({
    this.artistName,
    this.collectionName,
    this.trackName,
    this.artworkUrl,
    this.previewUrl,
  });

  @override
  Song fromJsonMap(Map<String, dynamic> json) => Song(
    artistName: json['artistName'],
    collectionName: json['collectionName'],
    trackName: json['trackName'],
    artworkUrl: json['artworkUrl100'],
    previewUrl: json['previewUrl'],
  );

  @override
  Map<String, dynamic> toJsonMap() => {
    'artistName': artistName, 
    'collectionName': collectionName, 
    'trackName': trackName, 
    'artworkUrl100': artworkUrl,
    'previewUrl': previewUrl,
  };
}