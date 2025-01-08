import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:scorehub/data/models/formationTeam.dart';
import 'package:scorehub/data/models/matches_of_day.dart';
import 'package:scorehub/data/models/player.dart';
import 'package:scorehub/data/models/static.dart';
import 'package:scorehub/data/repo/repo.dart';

part 'api_data_state.dart';

class ApiDataCubit extends Cubit<ApiDataState> {
  Repo repo;
  ApiDataCubit({required this.repo}) : super(ApiDataInitial());

  Future<void> getFixtures(String date) async {
    emit(Loading());
    try {
      Map<String, Map<String, dynamic>> leagueFixtures =
          await repo.getFixtures(date);

      emit(MatchesLoaded(leagueFixtures: leagueFixtures));
    } catch (e) {
      emit(ApiError(error: e.toString()));
    }
  }

  Future<void> getStatisticTeams(
      int idAwayTeam, int idHomeTeam, int idFixture) async {
    emit(Loading());
    try {
      List<Static> listStaitsticHomeTeam =
          await repo.getStaticsTeams(idHomeTeam, idFixture);
      List<Static> listStaitsticAwayTeam =
          await repo.getStaticsTeams(idAwayTeam, idFixture);
      emit(StatisticTeams(
          listStaitsticHomeTeam: listStaitsticHomeTeam,
          listStaitsticAwayTeam: listStaitsticAwayTeam));
    } catch (e) {}
  }

  Future<void> getFormTeam(int idFixture) async {
    emit(Loading());
    try {
      List<FormationTeam> ListFormTeam = await repo.getFormTeam(idFixture);
      emit(FormTeam(ListFormTeam: ListFormTeam));
    } catch (e) {
      emit(ApiError(error: e.toString()));
    }
  }
}
