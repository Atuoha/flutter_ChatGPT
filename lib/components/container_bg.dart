import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ContainerBg extends StatelessWidget {
  const ContainerBg({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: accentColor,
        border: Border.all(width: 0, color: accentColor),
      ),
      child: child,
    );
  }
}
