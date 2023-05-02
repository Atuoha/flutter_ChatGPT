import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ModelDropDownButton extends StatefulWidget {
  const ModelDropDownButton({Key? key}) : super(key: key);

  @override
  State<ModelDropDownButton> createState() => _ModelDropDownButtonState();
}

class _ModelDropDownButtonState extends State<ModelDropDownButton> {
  var selectedModel = 'text-davinci-002-render-sha';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      value: selectedModel,
      style: const TextStyle(color: Colors.white),
      dropdownColor: msgBg,
      iconEnabledColor: btnBg,
      items: [
        DropdownMenuItem(
          value: 'John',
          child: Text('John'),
        ),
        DropdownMenuItem(
          value: 'Philips',
          child: Text('Philips'),
        ),
        DropdownMenuItem(
          value: 'Enoch',
          child: Text('Enoch'),
        ),
      ],
      onChanged: (value) {
        setState(() {
          selectedModel = value!;
        });
      },
    );
  }
}
