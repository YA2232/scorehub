import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scorehub/app_router.dart';
import 'package:scorehub/business_logic/apiData/cubit/api_data_cubit.dart';
import 'package:scorehub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:scorehub/constants/strings.dart';
import 'package:scorehub/data/api/web_services.dart';
import 'package:scorehub/data/repo/repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthCubit(),
      ),
      BlocProvider(
        create: (context) =>
            ApiDataCubit(repo: Repo(webServices: WebServices())),
      ),
    ],
    child: MyApp(
      appRouter: AppRouter(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({required this.appRouter, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: homeScreen,
    );
  }
}
