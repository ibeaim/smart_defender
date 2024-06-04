import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_defender/constant.dart';

class RealtimeValueWidget extends StatefulWidget {
  final String databasePath; // Path to the value in the RTDB

  const RealtimeValueWidget({Key? key, required this.databasePath})
      : super(key: key);

  @override
  _RealtimeValueWidgetState createState() => _RealtimeValueWidgetState();
}

class _RealtimeValueWidgetState extends State<RealtimeValueWidget> {
  String value = ''; // Store the retrieved value

  @override
  void initState() {
    super.initState();
    fetchDataFromRTDB(); // Fetch data on widget initialization
  }

  Future<void> fetchDataFromRTDB() async {
    await Firebase.initializeApp(); // Initialize Firebase if not already done
    final databaseReference =
        FirebaseDatabase.instance.ref(widget.databasePath);

    databaseReference.onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists) {
        setState(() {
          value = snapshot.value.toString(); // Update state with the value
        });
      } else {
        print('No data available at ${widget.databasePath}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              value,
              style: kNumberTextStyle,
            ),
            const Text(
              'Distance',
              style: kLabelTextStyle,
            ),
          ],
        ),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: kActiveCardColour,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
    // Text(
    //   'Value: $value', // Display the retrieved value
    //   style: TextStyle(fontSize: 16.0),
    // );
  }
}
