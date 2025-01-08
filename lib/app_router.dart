import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scorehub/business_logic/apiData/cubit/api_data_cubit.dart';
import 'package:scorehub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:scorehub/constants/strings.dart';
import 'package:scorehub/data/api/web_services.dart';
import 'package:scorehub/data/models/matches_of_day.dart';
import 'package:scorehub/data/repo/repo.dart';
import 'package:scorehub/presentation/screens/home_screen.dart';
import 'package:scorehub/presentation/screens/mstch_screen.dart';
import 'package:scorehub/presentation/screens/splash_screen.dart';
import 'package:scorehub/presentation/screens/standings.dart';

class AppRouter {
  late ApiDataCubit apiDataCubit;
  AppRouter() {
    apiDataCubit = ApiDataCubit(repo: Repo(webServices: WebServices()));
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case homeScreen:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case standings:
        return MaterialPageRoute(builder: (context) => Standings());
      case matchDetails:
        final match = settings.arguments as MatchesOfDay;
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: apiDataCubit,
                  child: MatchScreen(
                    matchesOfDay: match,
                  ),
                ));
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Page not found!'),
            ),
          ),
        );
    }
  }
}
