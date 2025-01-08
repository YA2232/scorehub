class MatchesOfDay {
  String? nameOfLeague;
  int? idLeague;
  int? season;
  int? idFixture;
  int? idHome;
  int? idAway;
  String? logoOfLeague;
  String? homeTeam;
  String? logoHomeTeam;
  String? awayTeam;
  String? logoAwayTeam;
  String? dateTime;
  String? round;
  String? stadium;
  String? long;
  String? elapsed;
  String? extra;
  String? goalHome;
  String? goalAway;
  String? short;

  MatchesOfDay({
    this.nameOfLeague,
    this.idFixture,
    this.logoOfLeague,
    this.homeTeam,
    this.logoHomeTeam,
    this.awayTeam,
    this.logoAwayTeam,
    this.idHome,
    this.idAway,
    this.dateTime,
    this.round,
    this.stadium,
    this.elapsed,
    this.extra,
    this.long,
    this.goalAway,
    this.goalHome,
    this.short,
    this.idLeague,
    this.season,
  });

  factory MatchesOfDay.fromMap(Map<String, dynamic> map) {
    return MatchesOfDay(
      nameOfLeague: map['league']['name']?.toString() ?? "",
      idLeague: map['league']['id'] ?? 0,
      season: map['league']['season'] ?? 0,
      round: map['league']['round']?.toString() ?? "",
      stadium: map['fixture']['venue']['name']?.toString() ?? "",
      idFixture: map['fixture']["id"] ?? 0,
      elapsed: map['fixture']['status']['elapsed']?.toString() ?? "",
      long: map['fixture']['status']['long']?.toString() ?? "",
      short: map['fixture']['status']['short']?.toString() ?? "",
      extra: map['fixture']['status']['extra']?.toString() ?? "",
      logoOfLeague: map['league']['flag']?.toString() ?? "",
      homeTeam: map['teams']['home']['name']?.toString() ?? "",
      idHome: map['teams']['home']['id'] ?? 0,
      logoHomeTeam: map['teams']['home']['logo']?.toString() ?? "",
      awayTeam: map['teams']['away']['name']?.toString() ?? "",
      idAway: map['teams']['away']['id'] ?? 0,
      logoAwayTeam: map['teams']['away']['logo']?.toString() ?? "",
      dateTime: map['fixture']['date']?.toString() ?? "",
      goalAway: map['goals']['away']?.toString() ?? "0",
      goalHome: map['goals']['home']?.toString() ?? "0",
    );
  }
}
