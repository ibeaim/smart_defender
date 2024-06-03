import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_defender/components/icont_content.dart';
import 'components/reusable_card.dart';
import 'constant.dart';

enum FanState { off, on }

class RemotePage extends StatefulWidget {
  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  FanState fanState = FanState.off;
  int senddata = 2;
  int distance = 20;
  int servo = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Defender'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            distance.toString(),
                            style: kNumberTextStyle,
                          ),
                          const Text(
                            'Distance',
                            style: kLabelTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.fireFlameCurved,
                          label: 'Fire'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                        iconData: FontAwesomeIcons.caretUp,
                        label: 'Forward',
                      ),
                      onPress: () async {
                        await sendDataToFirebase(kForwardValue, kDefaultDelay);
                      },
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.caretLeft,
                          label: 'Turn On'),
                      onPress: () async {
                        await sendDataToFirebase(kTurnLeftValue, kTurnDelay);
                      },
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.circleStop,
                          label: 'Forward'),
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.caretRight,
                          label: 'Turn On'),
                      onPress: () async {
                        await sendDataToFirebase(kTurnRightValue, kTurnDelay);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCard(
                      colour: fanState == FanState.off
                          ? kActiveCardColour
                          : kInactiveCardColour,
                      cardChild: IconContent(
                        iconData: FontAwesomeIcons.fan,
                        label: 'Turn On',
                      ),
                      onPress: () async {
                        await sendFanStateToFirebase(fanState);
                        setState(() {
                          fanState = fanState == FanState.off
                              ? FanState.on
                              : FanState.off;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.caretDown,
                          label: 'Forward'),
                      onPress: () async {
                        await sendDataToFirebase(kBackwardValue, kDefaultDelay);
                      },
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.locationArrow,
                          label: 'Turn On'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ReusableCard(
                colour: kActiveCardColour,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Rotate Distance Check',
                      style: kLabelTextStyle,
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Color(0xFF8D8E98),
                          activeTrackColor: Colors.white,
                          thumbColor: Color(0xFFEB1555),
                          overlayColor: Color(0x29EB1555),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 15.0),
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 25.0)),
                      child: Slider(
                        value: servo.toDouble(),
                        min: 0.0,
                        max: 180.0,
                        onChanged: (double newValue) {
                          setState(() {
                            servo = newValue.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // RemoteControl(
            //   data: kForwardValue,
            //   delay: kDefaultDelay,
            // ),
            // RemoteControl(
            //   data: kBackwardValue,
            //   delay: kDefaultDelay,
            // ),
            // RemoteControl(
            //   data: kTurnLeftValue,
            //   delay: kTurnDelay,
            // ),
          ],
        ),
      ),
    );
  }
}

Future<void> sendDataToFirebase(int data, int durationInMilliseconds) async {
  // Reference to the database location for the integer data
  final databaseReference = FirebaseDatabase.instance.ref("car/command");

  try {
    // Set the value at the reference
    await databaseReference.set(data);
    print('Data sent to Firebase: $data');
    Future.delayed(Duration(milliseconds: durationInMilliseconds), () {
      databaseReference
          .set(kDefaultValue); // Replace 'defaultValue' with your default value
      print('Data reset to default: $kDefaultValue');
    });
  } catch (error) {
    // Handle potential errors
    print('Error sending data: $error');
  }
}

class RemoteControl extends StatelessWidget {
  RemoteControl({required this.data, required this.delay});
  final int data;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => sendDataToFirebase(data, delay),
      child: Text('Send Data: $data'),
    );
  }
}

Future<void> sendFanStateToFirebase(FanState fanState) async {
  // Reference to the database location for fan state
  final databaseReference =
      FirebaseDatabase.instance.ref().child('car/command');

  try {
    int valueToSend = fanState == FanState.on
        ? kFanButtonOnValue
        : kFanButtonOffValue; // Convert enum to integer
    await databaseReference.set(valueToSend);
    print(
        'Fan state sent to Firebase: ${fanState.toString().split('.').last}'); // Get human-readable state
  } catch (error) {
    // Handle potential errors
    print('Error sending fan state: $error');
  }
}
