import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants/colors.dart';

class TextLoading extends StatelessWidget {
  const TextLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.waveDots(
      color: Colors.grey.shade300,
      size: 30,
    );
  }
}
