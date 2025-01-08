// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:scorehub/data/api/web_services.dart';
import 'package:scorehub/data/models/formationTeam.dart';
import 'package:scorehub/data/models/matches_of_day.dart';
import 'package:scorehub/data/models/player.dart';
import 'package:scorehub/data/models/static.dart';
import 'package:scorehub/data/models/static_match.dart';
import 'package:scorehub/data/models/team_model.dart';

class Repo {
  WebServices webServices;
  Repo({
    required this.webServices,
  });
  Future<Map<String, Map<String, dynamic>>> getFixtures(String date) async {
    List<dynamic> matchesDay = await webServices.getFixtures(date);
    Map<String, Map<String, dynamic>> leagueFixtures = {};

    for (var match in matchesDay) {
      String leagueName = match["league"]["name"];
      String leagueLogo = match["league"]["logo"];

      if (!leagueFixtures.containsKey(leagueName)) {
        leagueFixtures[leagueName] = {
          "logo": leagueLogo,
          "matches": [],
        };
      }

      leagueFixtures[leagueName]!["matches"]!.add(MatchesOfDay.fromMap(match));
    }

    return leagueFixtures;
  }

  Future<List<Static>> getStaticsTeams(int idTeam, int idFixture) async {
    List<dynamic> list = await webServices.getStatisticTeams(idTeam, idFixture);

    List<StaticMatch> listStatic =
        list.map((e) => StaticMatch.fromMap(e)).toList();

    List<Static> static = listStatic
        .expand((match) => match.list)
        .map((e) => Static.fromMap(e))
        .toList();

    return static;
  }

  Future<List<FormationTeam>> getFormTeam(int idFixture) async {
    List<dynamic> formTeams = await webServices.getLineUps(idFixture);
    List<dynamic> players1 = [];
    List<dynamic> players2 = [];
    for (var formTeam in formTeams) {
      players1.addAll(formTeam["startXI"]);
      players2.addAll(formTeam["substitutes"]);
    }
    List<Player> startXI = players1.map((e) => Player.fromMap(e)).toList();
    List<Player> substitutes = players2.map((e) => Player.fromMap(e)).toList();
    return formTeams
        .map((e) => FormationTeam.fromMap(
            map: e, startXI: startXI, subistitute: substitutes))
        .toList();
  }

  Future<List<TeamModel>> getStandings(int season, int idLeague) async {
    List<dynamic> listTeams = await webServices.getStandings(season, idLeague);
    List<TeamModel> teams =
        listTeams.map((team) => TeamModel.fromMap(team)).toList();
    return teams;
  }
}
