import 'package:flutter/material.dart';
import 'package:smart_defender/constant.dart';

class IconContent extends StatelessWidget {
  IconContent({required this.iconData, required this.label});

  final IconData iconData;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          size: 60.0,
        ),
      ],
    );
  }
}
