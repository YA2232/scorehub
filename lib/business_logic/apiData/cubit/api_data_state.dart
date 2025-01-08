part of 'api_data_cubit.dart';

@immutable
sealed class ApiDataState {}

final class ApiDataInitial extends ApiDataState {}

final class Loading extends ApiDataState {}

final class MatchesLoaded extends ApiDataState {
  Map<String, Map<String, dynamic>> leagueFixtures;
  MatchesLoaded({required this.leagueFixtures});
}

final class StatisticTeams extends ApiDataState {
  List<Static> listStaitsticHomeTeam;
  List<Static> listStaitsticAwayTeam;
  StatisticTeams(
      {required this.listStaitsticHomeTeam,
      required this.listStaitsticAwayTeam});
}

final class FormTeam extends ApiDataState {
  List<FormationTeam> ListFormTeam;
  FormTeam({required this.ListFormTeam});
}

final class ApiError extends ApiDataState {
  String error;
  ApiError({required this.error});
}
