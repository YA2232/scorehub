class TeamModel {
  String teamLogo;
  String teamName;
  int rank;
  int points;
  int goalsDiff;
  int played;
  int win;
  int lose;
  int draw;

  TeamModel({
    required this.teamLogo,
    required this.teamName,
    required this.rank,
    required this.points,
    required this.goalsDiff,
    required this.played,
    required this.win,
    required this.lose,
    required this.draw,
  });

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    final teamData = map["team"];
    final allData = map["all"];
    return TeamModel(
      teamLogo: teamData["logo"] as String,
      teamName: teamData["name"] as String,
      rank: map["rank"] as int,
      points: map["points"] as int,
      goalsDiff: map["goalsDiff"] as int,
      played: allData["played"] as int,
      win: allData["win"] as int,
      lose: allData["lose"] as int,
      draw: allData["draw"] as int,
    );
  }
}
