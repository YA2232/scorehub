import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scorehub/business_logic/apiData/cubit/api_data_cubit.dart';
import 'package:scorehub/constants/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scorehub/data/models/matches_of_day.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiDataCubit apiDataCubit;
  late String dateTimeOfMatches;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    dateTimeOfMatches = DateFormat("yyyy-MM-dd").format(DateTime.now());
    apiDataCubit = BlocProvider.of<ApiDataCubit>(context);
    // startTimer();
    apiDataCubit.getFixtures(dateTimeOfMatches);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  // void startTimer() {
  //   timer = Timer.periodic(Duration(minutes: 1), (_) {
  //     apiDataCubit.getFixtures(dateTimeOfMatches);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF222232),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 7,
        backgroundColor: const Color(0XFF222232),
        title: const Text(
          "LiveScore",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              // البحث
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              // الإشعارات
            },
          ),
          IconButton(
              onPressed: () async {
                DateTime TimeOfMatches = (await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2050)))!;
                dateTimeOfMatches =
                    DateFormat("yyyy-MM-dd").format(TimeOfMatches);
                apiDataCubit.getFixtures(dateTimeOfMatches);
              },
              icon: Icon(
                Icons.date_range,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                BlocConsumer<ApiDataCubit, ApiDataState>(
                  listener: (context, state) {
                    if (state is ApiError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is Loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (state is MatchesLoaded) {
                      final leagueFixtures = state.leagueFixtures;
                      return Column(
                        children: leagueFixtures.entries.map((entry) {
                          String leagueName = entry.key;
                          List<dynamic> matches = entry.value["matches"];
                          String logoLeague = entry.value["logo"];
                          return Column(
                            children: [
                              Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 35, 38, 59),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: logoLeague,
                                              height: 20,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              width: 200,
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                leagueName,
                                                style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Color.fromARGB(
                                                      187, 255, 255, 255),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),

                              // Match Cards
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: matches.length,
                                itemBuilder: (context, index) {
                                  String date = matches[index].dateTime ?? "";
                                  DateTime dateTime = DateTime.parse(date);
                                  DateTime localTime = dateTime.toLocal();
                                  String time =
                                      DateFormat.Hm().format(localTime);
                                  bool isStarted() {
                                    if (int.tryParse(matches[index].elapsed) !=
                                            null &&
                                        int.parse(matches[index].elapsed) > 0) {
                                      return true;
                                    } else {
                                      return false;
                                    }
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              matchDetails,
                                              arguments: matches[index]);
                                        },
                                        child: isStarted()
                                            ? matchHasBeginn(
                                                matches[index].homeTeam ??
                                                    "Unknown",
                                                matches[index].awayTeam ??
                                                    "Unknown",
                                                matches[index].logoHomeTeam ??
                                                    "",
                                                matches[index].logoAwayTeam ??
                                                    "",
                                                matches[index].elapsed ?? "",
                                                matches[index].goalHome ?? "0",
                                                matches[index].goalAway ?? "0",
                                              )
                                            : matchNotBeginn(
                                                matches[index].homeTeam ??
                                                    "Unknown",
                                                matches[index].awayTeam ??
                                                    "Unknown",
                                                matches[index].logoHomeTeam ??
                                                    "",
                                                matches[index].logoAwayTeam ??
                                                    "",
                                                time,
                                              )),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget matchNotBeginn(String nameHome, String nameAway, String logoHome,
    String logoAway, String time) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 35, 38, 59),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 70,
              child: Text(
                overflow: TextOverflow.ellipsis,
                nameHome,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 5),
            Image.network(
              logoHome,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
          ],
        ),
        const SizedBox(width: 20),
        Text(
          time,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 20),
        Row(
          children: [
            Image.network(
              logoAway,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 5),
            Container(
              width: 70,
              child: Text(
                overflow: TextOverflow.ellipsis,
                nameAway,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget matchHasBeginn(String nameHome, String nameAway, String logoHome,
    String logoAway, String elapsed, String goalsHome, String goalsAway) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 35, 38, 59),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Image.network(
              logoHome,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 5),
            Container(
              width: 70,
              child: Text(
                overflow: TextOverflow.ellipsis,
                nameHome,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Text(
          goalsHome,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 10),
        Text(
          elapsed,
          style: const TextStyle(color: Colors.blue),
        ),
        const SizedBox(width: 10),
        Text(
          goalsAway,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(width: 20),
        Column(
          children: [
            Image.network(
              logoAway,
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 5),
            Container(
              width: 70,
              child: Text(
                overflow: TextOverflow.ellipsis,
                nameAway,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
