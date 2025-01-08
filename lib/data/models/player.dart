import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Player {
  String playerId;
  String name;
  String position;
  String grid;
  String playerPhoto;
  Player({
    required this.playerId,
    required this.name,
    required this.position,
    required this.grid,
    required this.playerPhoto,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      playerId: map['playerId'] as String,
      name: map['name'] as String,
      position: map['position'] as String,
      grid: map['grid'] as String,
      playerPhoto: map['playerPhoto'] as String,
    );
  }
}
