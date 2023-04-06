import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ass2/screens/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'constant/style_constant.dart';
import 'firebase_options.dart';
import 'screens/establishment.dart';
import 'screens/home.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  runApp(const ContactTrace());
}

class ContactTrace extends StatefulWidget {
  const ContactTrace({super.key});

  @override
  State<ContactTrace> createState() => _ContactTraceState();
}

class _ContactTraceState extends State<ContactTrace> {
  final currentUid = FirebaseAuth.instance.currentUser?.uid;
  String userType = "";

  Future<void> userStatus() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .get()
        .then(
      (value) {
        dynamic type = value.data();
        if (type != null) {
          userType = type['type'];
        }
      },
    );
  }

  Widget checkStatus(currentUid, userType) {
    if (currentUid != null && userType == 'client') {
      return UserScreen(userId: currentUid);
    } else if (currentUid != null && userType == 'establishment') {
      return EstablismentScreen(estId: currentUid);
    } else {
      return const HomeScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    userStatus();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          border: OutlineInputBorder(),
        ),
        textTheme: TextTheme(
          titleSmall: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
          displaySmall: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4ECDB1),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => const Color(0xFFFDE46E),
            ),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.black),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => const Color.fromARGB(50, 49, 248, 216),
            ),
            foregroundColor: MaterialStateColor.resolveWith(
              (states) => Colors.black,
            ),
            shape: MaterialStateProperty.resolveWith(
              (states) => roundedShape,
            ),
            side: MaterialStateProperty.resolveWith(
              (states) => const BorderSide(
                color: Color(0xFF4ECDB1),
              ),
            ),
          ),
        ),
      ),
      home: FutureBuilder(
        future: userStatus(),
        builder: ((context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : checkStatus(currentUid, userType);
        }),
      ),
      builder: EasyLoading.init(),
    );
  }
}