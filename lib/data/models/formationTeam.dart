import 'dart:convert';

import 'package:scorehub/data/models/player.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class FormationTeam {
  String teamNmae;
  int coachid;
  int coachName;
  int coachPhoto;
  String name;
  String formation;
  String coach;
  List<Player> startXI;
  List<Player> subistitute;
  FormationTeam({
    required this.teamNmae,
    required this.coachid,
    required this.coachPhoto,
    required this.coachName,
    required this.name,
    required this.formation,
    required this.coach,
    required this.startXI,
    required this.subistitute,
  });

  factory FormationTeam.fromMap(
      {required Map<String, dynamic> map,
      required List startXI,
      required List subistitute}) {
    return FormationTeam(
      teamNmae: map['team']["id"] as String,
      coachid: map['coach']["id"] as int,
      coachPhoto: map['coach']["photo"] as int,
      coachName: map['coach']["name"] as int,
      name: map['name'] as String,
      formation: map['formation'] as String,
      startXI: startXI as List<Player>,
      coach: map['position'] as String,
      subistitute: subistitute as List<Player>,
    );
  }
}
