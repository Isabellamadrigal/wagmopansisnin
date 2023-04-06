import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant/style_constant.dart';


class VisitLogScreen extends StatefulWidget {
  const VisitLogScreen({super.key});

  @override
  State<VisitLogScreen> createState() => _VisitLogScreenState();
}

class _VisitLogScreenState extends State<VisitLogScreen> {
  DateTime dateFilter = DateTime.now();

  Widget log(snap) {
    return snap.docs.length > 0
        ? ListView.builder(
            itemCount: snap.docs.length,
            itemBuilder: (context, index) => Card(
              margin: const EdgeInsets.only(
                left: 0,
                right: 0,
                top: 4,
                bottom: 4,
              ),
              child: ListTile(
                title: Text(snap.docs[index]['clientName']),
                subtitle: Text(
                    "Date Visited: ${DateFormat("MMM d, yyyy h:mm a").format(snap.docs[index]['visitDate'].toDate())}"),
              ),
            ),
          )
        : const Center(
            child: Text(
              "No result found on this date.",
              textAlign: TextAlign.center,
            ),
          );
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
        title: const Text("Establishment Visit Log"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.025,
          horizontal: 12.0,
        ),
        child: Column(
          children: [
            DateTimeFormField(
              mode: DateTimeFieldPickerMode.date,
              decoration: const InputDecoration(
                label: Text("Select Date: "),
                suffixIcon: Icon(Icons.event_available),
              ),
              onDateSelected: (value) {
                setState(() => dateFilter = value);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(logPath)
                    .where('visitDate',
                        isGreaterThanOrEqualTo: dateFilter,
                        isLessThan: dateFilter.add(const Duration(days: 1)))
                    .where('estId',
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) => (!snapshot.hasData)
                    ? const Center(child: CircularProgressIndicator())
                    : log(snapshot.data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}