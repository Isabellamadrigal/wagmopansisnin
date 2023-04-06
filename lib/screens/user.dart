
import 'package:ass2/screens/user_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:quickalert/quickalert.dart';

import '../constant/style_constant.dart';
import 'home.dart';


class UserScreen extends StatelessWidget {
  final String userId;
  const UserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    void logOut() {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: "Are you sure? ",
        text: null,
        confirmBtnText: "YES",
        cancelBtnText: "No",
        onConfirmBtnTap: () async {
          Navigator.pop(context);
          EasyLoading.show(status: "Processing...");
          await FirebaseAuth.instance.signOut().then(
            (value) {
              EasyLoading.dismiss();
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                  (route) => false);
            },
          );
        },
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.025,
          horizontal: 12.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: QrImage(
                  data: userId,
                  size: 300,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditUserScreen(userId: userId),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: roundedShape,
                  ),
                  child: const Text("Edit User Details"),
                ),
                OutlinedButton(
                  onPressed: logOut,
                  style: ElevatedButton.styleFrom(
                    shape: roundedShape,
                  ),
                  child: const Text("Log out"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}