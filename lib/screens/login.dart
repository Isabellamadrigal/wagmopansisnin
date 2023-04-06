import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ass2/screens/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../constant/style_constant.dart';
import 'establishment.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var obscurePassword = true;

  void login() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: "Processing... ");

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then(
        (userCredential) async {
          await FirebaseFirestore.instance
              .collection(collectionPath)
              .doc(userCredential.user?.uid)
              .get()
              .then(
            (DocumentSnapshot snap) {
              dynamic data = snap.data();
              String userId = userCredential.user!.uid;
              Widget landingScreen;
              if (data['type'] == 'client') {
                landingScreen = UserScreen(userId: userId);
              } else {
                landingScreen = EstablismentScreen(estId: userId);
              }
              EasyLoading.dismiss();
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => landingScreen,
                ),
                (route) => false,
              );
            },
          );
        },
      ).catchError(
        (err) {
          EasyLoading.showError("Invalid email and/or password. ");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log in",
        ),
        leadingWidth: leadWidth,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight,
            ),
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.025,
              horizontal: 12.0,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/illustration.webp"),
                alignment: Alignment.bottomCenter,
                opacity: 0.4,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Login your Account: "),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter an email address. ";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "Please enter a valid email address. ";
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter your password. ";
                          }
                          if (value.length < 6) {
                            return "Password should be more than 6 characters";
                          }
                          return null;
                        },
                        obscureText: obscurePassword,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: login,
                    // onPressed: () => validateInput(),
                    style: ElevatedButton.styleFrom(
                      shape: roundedShape,
                    ),
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}