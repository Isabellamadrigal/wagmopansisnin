import 'package:ass2/screens/register_establishment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../constant/style_constant.dart';
import 'login.dart';

import 'register_user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              alignment: Alignment.bottomCenter,
              opacity: 0.5,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.025,
            horizontal: 12.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              const Text(
                "Contact Trace",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                  "ContactTrace is a mobile app designed for tracing the travel history of users within MAD class.",
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 22),
              const Text("Welcome! Please choose to Sign In or Sign Up"),
              const SizedBox(height: 8),
              Expanded(child: Container()),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: roundedShape,
                ),
                child: const Text("Login"),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const RegisterUserScreen(),
                  ),
                ),
                child: const Text("Sign Up as Client"),
              ),
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const RegisterEstablishmentScreen(),
                  ),
                ),
                child: const Text("Sign Up as Establishment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}