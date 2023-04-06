import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ass2/screens/establishment_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/quickalert.dart';

import '../constant/style_constant.dart';
import 'home.dart';
import 'visit.dart';

class EstablismentScreen extends StatefulWidget {
  final String estId;
  const EstablismentScreen({super.key, required this.estId});

  @override
  State<EstablismentScreen> createState() => _EstablismentScreenState();
}

class _EstablismentScreenState extends State<EstablismentScreen> {
  String estId = FirebaseAuth.instance.currentUser!.uid;

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

  void invokeQrScan() async {
    String cancelButtonText = 'CANCEL';
    String colorCode = '#ffffff';
    bool isShowFlashIcon = true;
    ScanMode scanMode = ScanMode.QR;
    String qrScanRes = await FlutterBarcodeScanner.scanBarcode(
        colorCode, cancelButtonText, isShowFlashIcon, scanMode);
    if (qrScanRes != '-1') {
      EasyLoading.show(status: "Processing... ");
      try {
        FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(qrScanRes)
            .get()
            .then(
          (value) {
            FirebaseFirestore.instance.collection(logPath).add(
              {
                "clientId": qrScanRes,
                "clientName": "${value['lname']}, ${value['fname']}",
                "estId": estId,
                "visitDate": DateTime.now(),
              },
            );
          },
        );

        EasyLoading.showSuccess("QR Code logged successfully! ");
      } catch (e) {
        EasyLoading.showError("Invalid QR code. ");
      }
    } else {
      EasyLoading.showError("Invalid QR code. ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Establishment"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.025,
          horizontal: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: invokeQrScan,
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset("assets/images/scan-icon.png"),
                    ),
                    Center(
                      child: Card(
                        color: const Color(0xFFFDE46E),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            "Tap Here to Scan.",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const VisitLogScreen(),
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: roundedShape,
              ),
              child: const Text("Generate Visit Log"),
            ),
            OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) =>
                      EditEstablishmentScreen(estId: widget.estId),
                ),
              ),
              child: const Text("Edit Establishment Profile"),
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
      ),
    );
  }
}