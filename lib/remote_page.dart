import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_defender/components/card_button.dart';
import 'package:smart_defender/components/icont_content.dart';
import 'package:smart_defender/components/realtime_widget.dart';
import 'components/reusable_card.dart';
import 'constant.dart';

enum FanState { off, on }

enum ControlState { manual, auto }

final dataCommandReferance = FirebaseDatabase.instance.ref("car/command");
final dataFanReferance = FirebaseDatabase.instance.ref("car/fan");
final dataControlReferance = FirebaseDatabase.instance.ref("car/control");
final dataServoReferance = FirebaseDatabase.instance.ref("car/servo");
bool isPressed = false;

class RemotePage extends StatefulWidget {
  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  FanState fanState = FanState.off;
  ControlState controlState = ControlState.manual;
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
                      child: RealtimeValueWidget(
                    databasePath: 'ultrasonic/data',
                  )
                      //   ReusableCard(
                      //     colour: kActiveCardColour,
                      //     cardChild: Column(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         Text(
                      //           distance.toString(),
                      //           style: kNumberTextStyle,
                      //         ),
                      //         const Text(
                      //           'Distance',
                      //           style: kLabelTextStyle,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
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
                    child: CardButton(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.caretUp, label: 'Forward'),
                      onTapDown: () async {
                        await sendCommandToFirebase(kForwardValue);
                      },
                      onTapUp: () async {
                        await setCommandDefault();
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
                    child: CardButton(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.caretLeft, label: 'Left'),
                      onTapDown: () async {
                        await sendCommandToFirebase(kTurnLeftValue);
                      },
                      onTapUp: () async {
                        await setCommandDefault();
                      },
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.circleStop, label: 'Stop'),
                      onPress: () async {
                        await setCommandDefault();
                      },
                    ),
                  ),
                  Expanded(
                    child: CardButton(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.caretRight,
                          label: 'Turn Right'),
                      onTapDown: () async {
                        await sendCommandToFirebase(kTurnRightValue);
                      },
                      onTapUp: () async {
                        await setCommandDefault();
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
                    child: CardButton(
                      colour: kActiveCardColour,
                      cardChild: IconContent(
                          iconData: FontAwesomeIcons.caretDown,
                          label: 'Backward'),
                      onTapDown: () async {
                        await sendCommandToFirebase(kBackwardValue);
                      },
                      onTapUp: () async {
                        await setCommandDefault();
                      },
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                        colour: controlState == ControlState.manual
                            ? kActiveCardColour
                            : kInactiveCardColour,
                        cardChild: IconContent(
                            iconData: FontAwesomeIcons.locationArrow,
                            label: 'Auto'),
                        onPress: () async {
                          await sendControlStateToFirebase(controlState);
                          setState(() {
                            controlState = controlState == ControlState.manual
                                ? ControlState.auto
                                : ControlState.manual;
                          });
                        }),
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
                        onChanged: (double newValue) async {
                          setState(() {
                            servo = newValue.round();
                          });
                          await setServoValue(servo);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            const Text(
              'presented by group 7',
              style: kLabelTextStyle,
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> sendCommandToFirebase(int value) async {
  await dataCommandReferance.set(value);
  print('Data sent: $value');
}

Future<void> setServoValue(int value) async {
  await dataServoReferance.set(value);
  print('Data sent: $value');
}

Future<void> setCommandDefault() async {
  await dataCommandReferance.set(kDefaultValue);
  print('Data sent: $kDefaultValue');
}

Future<void> sendDataToFirebase(int data, int durationInMilliseconds) async {
  try {
    await dataCommandReferance.set(data);
    print('Data sent to Firebase: $data');
    Future.delayed(Duration(milliseconds: durationInMilliseconds), () {
      dataCommandReferance.set(kDefaultValue);
      print('Data reset to default: $kDefaultValue');
    });
  } catch (error) {
    print('Error sending data: $error');
  }
}

Future<void> sendFanStateToFirebase(FanState fanState) async {
  try {
    int valueToSend = fanState == FanState.on
        ? kFanButtonOnValue
        : kFanButtonOffValue; // Convert enum to integer
    await dataFanReferance.set(valueToSend);
    print(
        'Fan state sent to Firebase: ${fanState.toString().split('.').last}'); // Get human-readable state
  } catch (error) {
    // Handle potential errors
    print('Error sending fan state: $error');
  }
}

Future<void> sendControlStateToFirebase(ControlState controlState) async {
  try {
    bool valueToSend = controlState == ControlState.manual
        ? kManualValue
        : kAutoValue; // Convert enum to integer
    await dataControlReferance.set(valueToSend);
    print(
        'Control state sent to Firebase: ${controlState.toString().split('.').last}'); // Get human-readable state
  } catch (error) {
    // Handle potential errors
    print('Error sending fan state: $error');
  }
}
