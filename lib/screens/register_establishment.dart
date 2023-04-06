import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../constant/style_constant.dart';



class RegisterEstablishmentScreen extends StatefulWidget {
  const RegisterEstablishmentScreen({super.key});

  @override
  State<RegisterEstablishmentScreen> createState() =>
      _RegisterEstablishmentScreenState();
}

class _RegisterEstablishmentScreenState
    extends State<RegisterEstablishmentScreen> {
  //Establishment Profile Controllers
  final estnameController = TextEditingController();
  final contpersonController = TextEditingController();
  final estaddController = TextEditingController();

  //Establishment Login Credential Controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpassController = TextEditingController();

  //Other Variables
  final _formKey = GlobalKey<FormState>();
  var obscurePass = true;
  var obscureConfirm = true;

  void registerEstablishment() async {
    try {
      EasyLoading.show(
        status: "Processing... ",
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'null-usercredential');
      }

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection(collectionPath).doc(uid).set(
        {
          "estname": estnameController.text,
          "contperson": contpersonController.text,
          "estadd": estaddController.text,
          "type": "establishment",
        },
      );
      EasyLoading.showSuccess(
        "User account has been created successfully!",
      );
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password') {
        EasyLoading.showError(
          'Your password is weak. Please enter more than 6 characters. ',
        );
        return;
      }
      if (ex.code == 'email-already-in-use') {
        EasyLoading.showError(
          'Your account is already in use. Please enter a new email address. ',
        );
        return;
      }
      if (ex.code == 'null-usercredential') {
        EasyLoading.showError(
          'An error occured while creating your account. Please try again. ',
        );
      }
    }
  }

  void validateInput() {
    if (_formKey.currentState!.validate()) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: "Complete Registration? ",
        text: null,
        confirmBtnText: "YES",
        cancelBtnText: "No",
        onConfirmBtnTap: () {
          Navigator.pop(context);
          registerEstablishment();
        },
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: leadWidth,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("Sign Up as Establishment"),
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
                      const Text("Register your Establishment: "),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter your establishment name ";
                          }
                          return null;
                        },
                        controller: estnameController,
                        decoration: const InputDecoration(
                          labelText: 'Establishment Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter your contact person's name ";
                          }
                          return null;
                        },
                        controller: contpersonController,
                        decoration: const InputDecoration(
                          labelText: 'Contact Person Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter your establishment address ";
                          }
                          return null;
                        },
                        controller: estaddController,
                        decoration: const InputDecoration(
                          labelText: 'Establishment Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
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
                        obscureText: obscurePass,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => obscurePass = !obscurePass,
                            ),
                            icon: Icon(
                              obscurePass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "*Required. Please enter your password. ";
                          }
                          if (value != passwordController.text) {
                            return "Passwords does not match";
                          }
                          return null;
                        },
                        obscureText: obscureConfirm,
                        controller: confirmpassController,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => obscureConfirm = !obscureConfirm,
                            ),
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    // onPressed: () {},
                    onPressed: () => validateInput(),
                    style: ElevatedButton.styleFrom(
                      shape: roundedShape,
                    ),
                    child: const Text("Register"),
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