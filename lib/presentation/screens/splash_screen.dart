import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scorehub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:scorehub/data/api/web_services.dart';
import 'package:scorehub/data/repo/repo.dart';
import 'package:scorehub/presentation/widgets/show_modal_signin.dart';
import 'package:scorehub/presentation/widgets/show_modal_signup.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Repo repo = Repo(webServices: WebServices());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF222232),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 50.0,
        ),
        margin: EdgeInsets.only(top: 50, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/foto1.png"),
            SizedBox(
              height: 30,
            ),
            Text(
              "Discover all \n about sport",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "Search millions of jobs and ger the\n inside scoop on conpanies.\n Wait for what? Let is start it!",
              style: TextStyle(
                color: Colors.grey.withOpacity(0.4),
                fontSize: 15,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalSignIn(context: context);
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0XFF246BFD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalSignUp(context: context);
                  },
                  child: Text("Sign up",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
