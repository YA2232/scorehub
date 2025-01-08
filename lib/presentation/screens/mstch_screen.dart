import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scorehub/business_logic/apiData/cubit/api_data_cubit.dart';
import 'package:scorehub/data/api/web_services.dart';
import 'package:scorehub/data/models/matches_of_day.dart';
import 'package:scorehub/data/models/player.dart';
import 'package:scorehub/data/models/static.dart';

class MatchScreen extends StatefulWidget {
  final MatchesOfDay matchesOfDay;

  const MatchScreen({required this.matchesOfDay, super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  late String time;
  late String dateOfMatch;
  late String leagueName;
  late TabController _tabController;
  WebServices webServices = WebServices();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    webServices.getStandings(
        widget.matchesOfDay.season!, widget.matchesOfDay.idLeague!);

    BlocProvider.of<ApiDataCubit>(context).getStatisticTeams(
        widget.matchesOfDay.idAway!,
        widget.matchesOfDay.idHome!,
        widget.matchesOfDay.idFixture!);

    final date = widget.matchesOfDay.dateTime;
    if (date != null) {
      DateTime dateTime = DateTime.parse(date);
      DateTime localTime = dateTime.toLocal();
      dateOfMatch = DateFormat.yMMMMd().format(localTime);
      time = DateFormat.Hm().format(localTime);
    } else {
      time = "N/A";
    }

    leagueName = widget.matchesOfDay.nameOfLeague ?? "Unknown League";
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool isStarted() {
    if (int.tryParse(widget.matchesOfDay.elapsed!) != null &&
        int.parse(widget.matchesOfDay.elapsed!) > 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF222239),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            return Container(
              margin: EdgeInsets.only(top: screenWidth * 0.05),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.05),
                  buildMatchInfo(screenWidth),
                  SizedBox(height: screenWidth * 0.05),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white70,
                    indicatorColor: const Color(0XFFED6B4E),
                    tabs: [
                      Tab(
                        text: "Details",
                      ),
                      Tab(
                        text: "Stats",
                      ),
                      Tab(
                        text: "Line Up",
                      ),
                      Tab(
                        text: "H2H",
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.05),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildDetailsSection(
                            widget.matchesOfDay.nameOfLeague!,
                            widget.matchesOfDay.round!,
                            widget.matchesOfDay.stadium!,
                            time,
                            dateOfMatch),
                        buildMatchStatsSection(screenWidth),
                        buildLineUpSection(screenWidth),
                        buildH2HSection(screenWidth),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildMatchInfo(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth * 0.04,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTeamColumn(
              widget.matchesOfDay.logoHomeTeam!, widget.matchesOfDay.homeTeam!),
          Column(
            children: [
              isStarted()
                  ? Text.rich(TextSpan(children: [
                      TextSpan(
                        text: "${widget.matchesOfDay.goalHome}",
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.06),
                      ),
                      TextSpan(
                        text: "     ${widget.matchesOfDay.elapsed}     ",
                        style: TextStyle(
                            color: Colors.blue, fontSize: screenWidth * 0.06),
                      ),
                      TextSpan(
                        text: "${widget.matchesOfDay.goalAway}",
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.06),
                      )
                    ]))
                  : Column(
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                              color: Colors.blue[400],
                              fontSize: screenWidth * 0.06),
                        ),
                        SizedBox(height: screenWidth * 0.01),
                        Text(
                          widget.matchesOfDay.long!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ],
                    )
            ],
          ),
          buildTeamColumn(
              widget.matchesOfDay.logoAwayTeam!, widget.matchesOfDay.awayTeam!),
        ],
      ),
    );
  }

  Widget buildTeamColumn(String logoUrl, String teamName) {
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(logoUrl, width: 50, height: 50), // Display team logo
          SizedBox(height: 8),
          Text(
            teamName,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget buildMatchStatsSection(double screenWidth) {
    return BlocBuilder<ApiDataCubit, ApiDataState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is StatisticTeams) {
          List<Static> listHomeTeam = state.listStaitsticHomeTeam;
          List<Static> listAwayTeam = state.listStaitsticAwayTeam;
          print(listAwayTeam.toString());
          return ListView.builder(
            shrinkWrap: true,
            itemCount: listAwayTeam.length,
            itemBuilder: (context, index) {
              return buildStats(
                listAwayTeam[index].value.toString(),
                listAwayTeam[index].type,
                listHomeTeam[index].value.toString(),
              );
            },
          );
        }
        return const Center(
          child: Text(
            "No data available",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget buildLineUpSection(double screenWidth) {
    double fieldWidth = screenWidth;
    double fieldHeight = fieldWidth * 1.5;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: Column(
          children: [
            Stack(
              children: [
                // صورة الملعب
                Image.asset(
                  "assets/images/field.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: fieldHeight,
                ),
                BlocBuilder<ApiDataCubit, ApiDataState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is FormTeam) {
                      List<Player> list = state.ListFormTeam[0].startXI;

                      return Stack(
                        children: list.map((player) {
                          var gridPosition = player.grid.split(":");
                          int row = int.parse(gridPosition[0]);
                          int col = int.parse(gridPosition[1]);

                          double playerX = (col - 1) * (fieldWidth / 5);
                          double playerY = (row - 1) * (fieldHeight / 5);

                          return Positioned(
                            left: playerX,
                            top: playerY,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(player.playerPhoto),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  player.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return Center(
                      child: Text(
                        "Not Formation yet",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildH2HSection(double screenWidth) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: const Text("H2H", style: TextStyle(color: Colors.white)),
    );
  }

  Widget buildDetailsSection(String nameOfLeague, String round, String stadium,
      String time, String date) {
    return Column(
      children: [
        buildContainerOfDetails(labelName: "Competition:", value: nameOfLeague),
        buildContainerOfDetails(labelName: "Round:", value: round),
        buildContainerOfDetails(labelName: "Stadium:", value: stadium),
        buildContainerOfDetails(labelName: "Time:", value: time),
        buildContainerOfDetails(labelName: "Date:", value: date),
      ],
    );
  }

  Widget buildContainerOfDetails({String? labelName, String? value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0XFF222232),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labelName!,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                overflow: TextOverflow.ellipsis,
                value!,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStats(String home, String type, String away) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Color(0XFF222232), borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              home,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
            Text(
              type,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            Text(
              away,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
