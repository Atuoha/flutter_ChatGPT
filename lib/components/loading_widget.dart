import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key, this.size = 70}) : super(key: key);
  final double size;

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.hexagonDots(
      color: btnBg,
      size: size,
    );
  }
}
